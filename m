Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C292D218B87
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgGHPkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbgGHPkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:40:37 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF11C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:40:37 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w17so3875594ply.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c+AViKmZWXa5Qq0T1PCRfKeqJTYAKAd7rY72vBWmN00=;
        b=ADDqxWar0kueN8iiJgXMwOewN2utQ80dtye3BX4gcW5UxIZt6cjK81GxskbKGYjD/t
         a8p6X7gTmW3SJTc6orNHTmLilZRMGCglNx+AeuWZVV9yAOb+/bbUWFLOI8mE4RtkoR07
         lqY/xfTEEAvxopG1Wua2ntIFUz5LDcUnk6ISp+HbiyR2VYQt0YvTdR+z8pU+Rngz8Tfb
         YjDGZezgGr2oICXmO2XGSVcarLTs8lkOhaY/KJcnlndkP0xUTdbpGB7m2ISDONDBTxWB
         Hk3icnxq9Pq8LIC9+qU6XdWLx6LQ67cebg/mnkTBlkax3YseZ7U/KFSG6tXR/rTwQ0A3
         k4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+AViKmZWXa5Qq0T1PCRfKeqJTYAKAd7rY72vBWmN00=;
        b=XKfcsxoj4zc9JVb8JgFarkBvRjP4l+lRC+6ei2TIbVS++pBXuHg/vylX9xh7DMyyFi
         ebzHwBFIJ1Y1Vlc4zXjYe80py5LIa7/Q5wk7V5nIIIuoIpynI/sQdgBJelU4KDcFWd+u
         F8EJYwQecY6Il8xiLEE5y89TIX8kOjPuYl/1ze9HUrqR8gt9w+gKIixR73Ob6xFmOid6
         uwp+bhkLSz9Ck9OuPsH7lEaGQEMEhhYvXhv0g/EgwUkGfYWd8mT1leYnb5dp4GgcQXW/
         Oun1JvzzEfKd6FHubFCZsyRK1zULjJrkPwjzKlBSMDCeGyFl7CwuYo7YIxTfGOejzAVK
         vaKQ==
X-Gm-Message-State: AOAM533G7803NtOSnYDAyVltQr59P1AF4qMDUBrNOXzRoRzeYxmw5V7G
        W/nCQKdqfSUwI4SlLwfxHyqoX4bvII8qwg==
X-Google-Smtp-Source: ABdhPJwhhCoWeAJHM1l563Ydy7qip5u/F6W0TxKXJ1kP6s/h36GGUPVsFcieNn74+GNo/kv2XIepvw==
X-Received: by 2002:a17:902:a70e:: with SMTP id w14mr6821580plq.259.1594222837288;
        Wed, 08 Jul 2020 08:40:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l9sm55994pjy.2.2020.07.08.08.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 08:40:37 -0700 (PDT)
Date:   Wed, 8 Jul 2020 08:40:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] nstat: case-insensitive pattern matching
Message-ID: <20200708084028.143d1181@hermes.lan>
In-Reply-To: <20200708123801.878-1-littlesmilingcloud@gmail.com>
References: <20200708123801.878-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jul 2020 15:38:02 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> The option 'nocase' allows ignore case in the pattern matching.
> 
> Examples:
>     nstat --nocase *drop*
>     nstat -azi icmp*
> 
> Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>

On second thought, this looks like a good idea.
Perhaps it should also be applied to ifstat and ss.
