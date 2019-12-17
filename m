Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2F122349
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLQEyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:54:08 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:41599 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLQEyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:54:07 -0500
Received: by mail-pj1-f65.google.com with SMTP id ca19so3993016pjb.8
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 20:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXoGXsFN0fsYNcjgwQxsCqvxbFgm9nLOO1FjTN27brQ=;
        b=VJ6bj5oYCxDaO6XY/xOIAOF4Y+9gosAry28wKGwpUGSuxoROGlAvQHkL44kyRxMObc
         rny6toAW/rC5AduLszZATEzXhZgviTuNFQVqsDlg1KcAgYGT/oX2dlG5Cdc5IiV1dd/Z
         gLAZodJaD0B4f6HWAlR5lgaSsDwTxOOxHu5mXur5JUIXObkdvbJr5Aecn0YIFOpmgrkB
         xflmrdobRTUPBBBWFYLlmXPt5HTL6LDwiVGv9zhSJtChhu1n51AsG7ecREmCmFayTwV4
         yrnf7i/CstjfTLO31E+RN66kbaxpsqZeFP4tu3ShtzGVJc93ybaq/7zVXDmSIGSHv+6D
         L+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXoGXsFN0fsYNcjgwQxsCqvxbFgm9nLOO1FjTN27brQ=;
        b=gj5BmPA37NztF44KatlR0PU8SGY/y05cuBxNWk2NFQHd3o/5LWwGQiXB7qAj6lTz79
         AX1dRXbR2Ldr4G8pr+UjEgXdjKbNmsTftUeRbTtvf9Rz361060QzWOSpCPhRdCKR/arb
         Ag/bRNsdayGVgjqNX1tL7PmyoY83ih8G9SxTCOUjZMNz+WHlAn6eWG/Dw1WLJwxySmeW
         rFRuBJjXQytRIIZdqSmI+RIsPOVkXiB6p6bJrClsHHiTDVZul33kbVhos1BPKNnanLgZ
         eUjx4MtQi48uQwYs6oB2xu3WornlrI88txwBNqZKoaAG6FO8NnrUvuFo9jqaHrSn3Fv2
         KWZg==
X-Gm-Message-State: APjAAAXhg6kIdx5uugOSoRKKcSaMFrjder6hma2aXpcNZxKpYlvDl3UM
        DzLfV3vTkwOdzZvO4SBAUOCcDw==
X-Google-Smtp-Source: APXvYqzonrrUR6oBnI0rDLTkR+BNbvxndCauQaGQzHRij5pPUaZWy+PqoNh+hZgWLYe368V4Ug4gkg==
X-Received: by 2002:a17:902:8309:: with SMTP id bd9mr19998598plb.113.1576558447101;
        Mon, 16 Dec 2019 20:54:07 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f30sm24905124pga.20.2019.12.16.20.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 20:54:06 -0800 (PST)
Date:   Mon, 16 Dec 2019 20:53:51 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        ayal@mellanox.com, moshe@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH iproute2 0/3] Devlink health reporter's issues
Message-ID: <20191216205351.1afb8c75@hermes.lan>
In-Reply-To: <20191211154536.5701-1-tariqt@mellanox.com>
References: <20191211154536.5701-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 17:45:33 +0200
Tariq Toukan <tariqt@mellanox.com> wrote:

> Hi,
> 
> This patchset by Aya fixes two issues: wrong time-stamp on a dump in
> devlink health reporter and messy display of non JSON output in devlink
> health diagnostics and dump.
> 
> 1) Wrong time-stamp on a dump in devlink health reporter: 
> This bug fix consist of 2 patches. First patch refactors the current
> implementation of helper function which displays the reporter's dump
> time-stamp and add the actual print to the function's body.
> The second patch introduces a new attribute which is the time-stamp in
> current time in nsec instead of jiffies. When the new attribute is
> present try and translate the time-stamp according to 'current time'.
> 
> 2) Messy display of non-JSON output in devlink health diagnostics and dump:
> This patch mainly deals with dynamic object and array opening. The
> label is stored and only when the proceeding value arrives the name is
> printed with regards to the context. 
> 
> Series generated against the shared master/net-next head:
> 24bee3bf9752 tipc: add new commands to set TIPC AEAD key
> 
> Regards,
> Tariq
> 
> Aya Levin (3):
>   devlink: Print health reporter's dump time-stamp in a helper function
>   devlink: Add a new time-stamp format for health reporter's dump
>   devlink: Fix fmsg nesting in non JSON output
> 
>  devlink/devlink.c | 153 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 119 insertions(+), 34 deletions(-)
> 

Applied, devlink really needs to get converted to same json
library as rest of iproute2.

