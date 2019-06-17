Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7311E4957B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfFQWyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:54:17 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36855 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfFQWyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:54:17 -0400
Received: by mail-qt1-f193.google.com with SMTP id p15so12961210qtl.3
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cT8QGQwizmK2289yO/kCmnme6zuHHbrVFt//kxAHaIQ=;
        b=XNLE6aOk3itLtG0Gt6zweWLCsIU32Kzw9lxBAHq0Oqvwk4+Brhn3xD4NaArf7+4y6S
         j6+RhMxEQhodgUY3Ua9643jwFBWjwB1FjN1dnmTKmeKBQkua4ZsoEwijJOlp96z3BZMM
         Di1qHSpaO1inDKDqsMDZftZ1SDL5Q9ySg5lFKwdVpq43gfcpTpUlr3U4KwS0JoyYmPMd
         WdEDih3kDKcWXc+VFLNsXKAHYsLdN8zDW7eKXjXXFmh0hT5sk+wSPkKyTle2fk0TiaU2
         ++SKu6MkC7DchwsphCdLIBJyXkXdX1DaIWpv/YUrs+l/7AjNT5FAiJqG/43q/2GASIdv
         ufEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cT8QGQwizmK2289yO/kCmnme6zuHHbrVFt//kxAHaIQ=;
        b=Xobl2lmN1Rb+aSJUc12kuR2U0GPhIlz2QX5JkpJnKcvGgCoBwDJxVttO6CCZTjvOyw
         mXlE25m6uqfEGhi2G+7CAoWtoEZsNCVF3Ztlu6c1HTdK46RpXf13a1EwaWMXxG/tDazr
         HNgglRktBCWzmNnOcKr+aI+MXVYbT6pTzl4vAp9MAi4TCoc//DRCf+9mnUbF6hJwQNMr
         SvcJ2WhBTLIIXRSeWVJ/NyjEJDwFDkM4wFVh1DbBv86AoMwZGehi338cuU5L5mUAugSE
         gcNV/lk9LOJhZhiXhiyXwdXOafk/RIs0rb10+Iv/C62Kfz9BFw1RhN9q5rCvv8IQoxHK
         jYzg==
X-Gm-Message-State: APjAAAVckhsKVTRv/8rXrOP9P8NwDSk/VD5vnLhanCfRNxS5qCyivnwE
        7MIp/0r6qZ2Kwor2zsC4alyMuw==
X-Google-Smtp-Source: APXvYqzFNpRnhlxgU2zFY4LfcJwWzfwHvUO2kE4dgTRbn8yYFKKwZmsRaBk3g75p66a5eG/dkNEv+w==
X-Received: by 2002:ac8:124c:: with SMTP id g12mr65571457qtj.57.1560812056476;
        Mon, 17 Jun 2019 15:54:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u1sm10037730qth.21.2019.06.17.15.54.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 15:54:16 -0700 (PDT)
Date:   Mon, 17 Jun 2019 15:54:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <mkalderon@marvell.com>, <aelior@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 4/4] qed: Add devlink support for configuration
 attributes.
Message-ID: <20190617155411.53cf07cf@cakuba.netronome.com>
In-Reply-To: <20190617114528.17086-5-skalluru@marvell.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
        <20190617114528.17086-5-skalluru@marvell.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 04:45:28 -0700, Sudarsana Reddy Kalluru wrote:
> This patch adds implementation for devlink callbacks for reading/
> configuring the device attributes.
> 
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

You need to provide documentation for your parameters, plus some of
them look like they should potentially be port params, not device
params.
