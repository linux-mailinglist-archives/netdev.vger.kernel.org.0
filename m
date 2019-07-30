Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666657B5CA
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbfG3WkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:40:20 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:32874 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388218AbfG3WkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:40:20 -0400
Received: by mail-qk1-f175.google.com with SMTP id r6so47816937qkc.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 15:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FcdD8hB8Ux5zzdiIByM+C5hDcyBT/7SmcXJEafAzSig=;
        b=qfRkNVBrOFvXcF23LEtbBKxdcq3PSUrPu9gh3JKGL+yUm2gMyzMkQlh86VC52GX1XH
         R65mkOQR2FRxRbcpv8XUoFev3bmonW54lA/LnRcZzTpgVrUC7QPxBH+jLz/kCVl1fSu4
         vyX6nrZ4ujvTbg/wlurHGb9uWel6M3R5xtn/0fMLabiN8whoilS7Aq7GAwbZMsl7bW+o
         ds4NVIP8tGKsoGB7uo+/kxYo7/sNKXPNlXZ3EEK+aDVwEAOr4sLU3vA0/h37yL6xpNd+
         Lnn0vGTjpYfW7yAQ/kVYtoWbDxDKILBxvJXtHhq+N6WLsxVetuMY3sJskywC0RZvb2Yf
         Bghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FcdD8hB8Ux5zzdiIByM+C5hDcyBT/7SmcXJEafAzSig=;
        b=NS6ZZA4+jL53R+lp+4S7GEVgJQ/QLOL47nX42dSRisODBu7wlpOiH86PLisTqXVF88
         EsV5YrOKudpvoXfSY9gIMTQj6CYPEv2Ad2VFN8We53o1dLAHrvBKKxm7Z2HBpTqWbhgw
         CKEuxwghRCiQuXn4nbjkG2zvwIIO3adg9QB/z29U80MRkU2vxTti3gExTDkzCzugAaE3
         ESKddxQi9Z8aaext9PBkm7qRL/VrC63hf4KmD7zSu+DiTyngaRhvoJJqICA/e9zbiXpp
         QTytPN+dWD8U8H1P+MAd1kLH8Nhwj6rI5TW4+jGipUs/xWnLPDPxlDv+CBMTCDJZ7k2W
         Eq0Q==
X-Gm-Message-State: APjAAAWqfHdTyQm2zCWk6ulsDHmhMuMs4ChD3CHwS3JtQngCsgJe1TUr
        VuL7xXMxPw5ShnUWn6eulFkdKw==
X-Google-Smtp-Source: APXvYqyDnhsCYYwN1q08eAVRID8pFU+dl/3dr3b3905W/w+zar5BcyJ+N9W7L06cFtXunlL9C1oyqQ==
X-Received: by 2002:ae9:f107:: with SMTP id k7mr13915939qkg.215.1564526419104;
        Tue, 30 Jul 2019 15:40:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i23sm29117321qtm.17.2019.07.30.15.40.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 15:40:19 -0700 (PDT)
Date:   Tue, 30 Jul 2019 15:40:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/3] net: devlink: export devlink net
 set/get helpers
Message-ID: <20190730154006.405c445b@cakuba.netronome.com>
In-Reply-To: <20190730085734.31504-3-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
        <20190730085734.31504-3-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 10:57:33 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Allow drivers to set/get net struct for devlink instance. Set is only
> allowed for newly allocated devlink instance.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
