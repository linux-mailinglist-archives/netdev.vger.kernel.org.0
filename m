Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593BACCB0F
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 18:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfJEQRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 12:17:00 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:37852 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfJEQRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 12:17:00 -0400
Received: by mail-pf1-f171.google.com with SMTP id y5so5772741pfo.4
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 09:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+NxVeQilGOZgHjUgyF2RdYtat9ECLUkDHf4z5oCUZPE=;
        b=ydsZGFURhhHqnxpj2aOHOqJnXXXrZPrrYXVqYOc1kq5pqmPspBJRuKg0bfcGyQN2P2
         p+EoI0kWfg17c2ObD370xHMUeVTFPOjK1JrKUO69KcTPPD3442nfjBnFBtuns40YMUSZ
         7nD8uhlbFGWnN5rD/9zrx7or7MVO5PBQaBVH73oDIr5Z7kALHF8yOW1xN9Knkll1RMEj
         vkVCpwEBfTBPRqdJPmQY4UnsvUDny1rZ2xw5mrR0Ehk6B8bIMffB9kbVSh4hVtYwoB0R
         WM7A1k9vI2ZFdHywmQbmOBsIee9uhFCnVNsivD5X3ZOXM2kGu1xg/PsAE+8yTScXyCZf
         UNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+NxVeQilGOZgHjUgyF2RdYtat9ECLUkDHf4z5oCUZPE=;
        b=lkqu8K5lwl9F6RLg6k4KlL2LVz8qSkydfjBHko/c8qNBMuTlos09RvgxhYDpAONLTG
         8qw5cBFoVXGLA1tlJT4iIVYPuElf+cfBaKhhPRpiKiRxR7zJ9UiQvivwq2VlGAL2DWae
         19mIM5M+t2wR+DlGdLzcLMO6FAcCppU7+hx8eWwB9wndE0RVjO+V/fFtdb2v4MFe48WC
         vgm2E3+fKujWHt1MpE6VS0H/LZRktkeW8V6kLdR7FFrlBivt4ndvt9NbcafyqSEDPEkI
         8JGbSwBP6Lc6L7rf7gupvhBIvNWFDG0dbyFAKxWhgxAT/UoJnzhZw5eZJX6bLjs2/9xW
         4RJQ==
X-Gm-Message-State: APjAAAUGeyYFxeJfd+FgaVpCOMeYHbgkqMnEbIGe4SsjBLAIs2zZHvg5
        1CKoHUNQi/CLFnS6TXzYYvHhZw==
X-Google-Smtp-Source: APXvYqx/7ifPi1j7Gc4Ll40XnD/hYN+BcK1b5/JGkOh2in1dTdIArtWDcRAqtmj2iQRq+Q7bSabsrg==
X-Received: by 2002:a17:90a:b012:: with SMTP id x18mr24205048pjq.116.1570292219574;
        Sat, 05 Oct 2019 09:16:59 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id s1sm3943824pgi.52.2019.10.05.09.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 09:16:59 -0700 (PDT)
Date:   Sat, 5 Oct 2019 09:16:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        petrm@mellanox.com, tariqt@mellanox.com, saeedm@mellanox.com,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/3] create netdevsim instances in namespace
Message-ID: <20191005091654.346ced3a@cakuba.netronome.com>
In-Reply-To: <20191005061033.24235-1-jiri@resnulli.us>
References: <20191005061033.24235-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Oct 2019 08:10:30 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Allow user to create netdevsim devlink and netdevice instances in a
> network namespace according to the namespace where the user resides in.
> Add a selftest to test this.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
