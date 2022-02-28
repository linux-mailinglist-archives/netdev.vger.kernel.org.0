Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8B54C7270
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiB1RWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiB1RWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:22:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D8B7F6CD
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:21:37 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so11915226pjb.3
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cV+XZ3kZ3TU+iIz61WEk/aD2eYRfwHkGjaCobQPOplA=;
        b=on9tQJgWp2cHEyUpvYj2J+l/kgsnETc64dsKSb0UjQ3JZsUyGQN7Ms6ngG153M1NtE
         VuguctpyeFmt7OhWMfg3iGvnGUBYkqt21iUZJGs/Hbt3CtZBtRRM/0cnI8zf8OApIiV9
         99vSeDD2WOpdGLg8THOA87n9gbVVSPFBWZ2IT2euk5kiUUYXZUIMrlqIXluFTbVEEsP5
         fgg1vqPbBV6KS7q2susR7m06T2nC7l2q8xWGdx8tDecL2JTPiIFBysRK5Ic04Eng6nLB
         YMjJQmpn8pI2DrL1oS6ITsyJX93sPFsbUG8jnUTMJivF1/fLB/2aAYXLs2Iybje0/4XY
         0qUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cV+XZ3kZ3TU+iIz61WEk/aD2eYRfwHkGjaCobQPOplA=;
        b=oEtyvqCrZVEeD8vXoTqMmeGsbikdj+EgjIG/+GGTpqBVsyvF40wY9ivmw8dnV72DJO
         DKhtFyu65eAurGczeocmoBi0XO/2cUWYNMBqeA4oxOTjFCOMPnTGw6mHr2ubKnQ1j0/P
         0oLbFpegKqwHPtcIcJjxQ3dbbBDHgNcLdca9wrAPXPIk/ofEyOBJfb1Jj0Hb7vB90Ol2
         tCnyOzD+uYJk3Z5Nw6BKtOzi+0R9Jk7QX+LuRX+KY34cfDythY+dGUklIbBjHKxhd5XW
         ATkMHUIgsAesmzmKyRpYtQb5Q+I8GL1fkQ8ryEPQ6ORgxr/idjW1Y0xq/caYUWHBDGFp
         +xZg==
X-Gm-Message-State: AOAM531u7UQlOKgY4CdjRqcgj4aUfNV+HaLl8lScfYdnJwe2sVKFgGkO
        Ctn586hcH7JFyCQEyq5vr3hXBfFljXgTQzmF
X-Google-Smtp-Source: ABdhPJzvsrVmHHMvOeqTwYE2ypCXjVk8SYZXA1pcrQidK4mI6xnli/Bt+CmS6oXT/6TKI+3FF7kn/Q==
X-Received: by 2002:a17:902:b103:b0:14f:aa09:f23a with SMTP id q3-20020a170902b10300b0014faa09f23amr22123323plr.25.1646068896489;
        Mon, 28 Feb 2022 09:21:36 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z13-20020a63e10d000000b003733d6c90e4sm10557607pgh.82.2022.02.28.09.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 09:21:36 -0800 (PST)
Date:   Mon, 28 Feb 2022 09:21:33 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Daniel Braunwarth <daniel@braunwarth.dev>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/2] lib: add profinet and ethercat as
 link layer protocol names
Message-ID: <20220228092133.59909985@hermes.local>
In-Reply-To: <20220228134520.118589-2-daniel@braunwarth.dev>
References: <20220228134520.118589-1-daniel@braunwarth.dev>
        <20220228134520.118589-2-daniel@braunwarth.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 14:45:19 +0100
Daniel Braunwarth <daniel@braunwarth.dev> wrote:

> Update the llproto_names array to allow users to reference the PROFINET
> and EtherCAT protocols with the names 'profinet' and 'ethercat'.
> 
> Signed-off-by: Daniel Braunwarth <daniel@braunwarth.dev>

This is legacy table. Original author did choose to use stanard
file /etc/ethertypes. Not sure why??
