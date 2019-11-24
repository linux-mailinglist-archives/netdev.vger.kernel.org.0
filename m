Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56E710856B
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 23:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfKXWzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 17:55:45 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34411 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfKXWzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 17:55:45 -0500
Received: by mail-pj1-f67.google.com with SMTP id bo14so5557051pjb.1
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 14:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jk+fNxzDV6BmEThNpWomFGAXnnxI+LCrDfltw2gh2wU=;
        b=1ymce5OR3Eaceq3z3gT6DfUlNhkLiIN67Eui1QwhgQI8xJXyv+jN1tYB4ppNoE0t8+
         DRnVfinqzYWUDiN49qqwrNL9wAyt94CciNRIQC55hjmBdr7hKkYg3JkZSTab9LEh16Op
         uo4F09O+gMCiypuIojsvpOqlSXCSG0jLw32pvlyPFyObsJubrn1R4+jkJzrBSfgbzGya
         XpXUnLl8KbcVV5/6aWLyKm4bc0iHgJNaF1aqx0tJUqWHSJiYok0SAXBKtJ6UwLcQo17l
         ILXn4cV5uUfnQQOHDo3w4PiimwngW6y6T2Mqd9eB9hKopyp1GD03SXvWriEYOUHwlml8
         G+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jk+fNxzDV6BmEThNpWomFGAXnnxI+LCrDfltw2gh2wU=;
        b=T+MJhCZa4Icni5db1nmtfXEIQ5WqJs/qxflEMKwEFc5Zq18+xOJQ/VTzCCqmrCDpaf
         bGLxZDj/ZaQHboZZ9qYCQ3ffGMLuoiDB/wzCcLx7mnAQ0Iu5Bt2Z7sWtPC6ZKgdgoUvg
         c2UG/JvFESQuGZ2NMH+8LTvVZHkv9S5NCR8av8GHRjuofuilt7EYvLqPS8BSTKZECObj
         TXr61MxakjXNPpQdWa2Mjesj4WXubUGja4ZGjlbFkiNJ0+3R1wqrkRJGbS/SvChhX5E9
         KeYEry5gWS7aU9XpvzuxaI2EJsKvUhIGTTH9SIhqjiSEFtuOh9LsYtLckETnED0OkLNY
         Glqg==
X-Gm-Message-State: APjAAAWn5c1G05vw/061nqHZe19/BLLwSf5gkyb7uSj5k7+xj22shPsE
        DgcH6YkEPulgxOIalgxE/hXngJWukQ4=
X-Google-Smtp-Source: APXvYqyPUWoWWKSdH0/kKWf5zYkwpIOUMgTQGUnyMzYBcaU4GxClcjKettpinMxOr1qgmPZ/tejEug==
X-Received: by 2002:a17:902:8a83:: with SMTP id p3mr25810862plo.79.1574636144037;
        Sun, 24 Nov 2019 14:55:44 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id a3sm5473425pjh.31.2019.11.24.14.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 14:55:43 -0800 (PST)
Date:   Sun, 24 Nov 2019 14:55:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/13] bnxt_en: Updates.
Message-ID: <20191124145538.7c5075ac@cakuba.netronome.com>
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 22:30:37 -0500, Michael Chan wrote:
> v2: Dropped the devlink info patches to address some feedback and resubmit for
> the 5.6 kernel.
> 
> This patchset contains these main features:
> 
> 1. Add the proper logic to support suspend/resume on the new 57500 chips.  
> 2. Allow Phy configurations from user on a Multihost function if supported
> by fw.
> 3. devlink NVRAM flashing support.
> 4. Add a couple of chip IDs, PHY loopback enhancement, and provide more RSS
> contexts to VFs.

Applied, thank you!
