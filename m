Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4224C97DE
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiCAVoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiCAVoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:44:01 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B6C1C137;
        Tue,  1 Mar 2022 13:43:19 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 195so15374132pgc.6;
        Tue, 01 Mar 2022 13:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lb58kIninGqH33dDlVGnMq4+pgo6WtkdVDrcMZz1aRo=;
        b=OICJMV5BhoUWd7xGXKzqVm4LJ+nbkh12WQmy2J8uLvLb5967f/WxtuNtdGVUVFUZLC
         tClRvP/UtNLL5wvCKX1AyKDNs/ud+CW6QtFTm0HfRsj9a0he7jqcoejN1uq79syxZEAC
         vM+qqz95PZzwBh288izoCVMx7Hhm/cnDRhNVPsCk4FlRxBPJ5q5bDjI7cTirbNZoP7nM
         8YpwiEKp4+Y767KglC/53xb0VpqKidxwo9k/8opjCurGidjl5Yzgp2nfh30xvoZeAE5O
         kxDfg+r0iOrdTA5CBt2TdOcrbcImjbr3U48649k35ebBhaI/YovnPLstWXtQZ9ItLubT
         OiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lb58kIninGqH33dDlVGnMq4+pgo6WtkdVDrcMZz1aRo=;
        b=4yVp4fZUD/4B5ZsKjegjb2/BJmT8GFhJi/W0ISenwuVp/EVnUlwgeCCxGX6jb4rqCc
         B+cX1KyRqgzd4ASfhQnYrIFUS8NwZUG86w4rjkrA84NbxbrYGawjkt57jb+dra9lurBT
         4uk86o57S8T7DPFXZ8fX2hvIkIttLOc0FmWorICv3m4bZ2frOTp1zficKyppA+yLhm/W
         Xpd75IzuYe3Oyinla3NZPTin1bPlG/XAkZMU0dsr/TFFBWv1E/JUpGgSWNCrQVhntW58
         f/Z+E45qhTqbDGegnSij8kC4RPtyqkJPZiSdwc52hdFZm1eRQX7nKjdt9n0IyaRrqgS/
         lBGA==
X-Gm-Message-State: AOAM533O0V2TZuYKRZ1invxStEX0suKKnwqUJmv7KMZElZjlRTHW/Ued
        0yZg1cWCfB/uQ0mxjRBB4J0=
X-Google-Smtp-Source: ABdhPJw2ch/EZmG6VJ4jUaRf99B9jwtLjGAjDNP2OylB8aAoJc/ktHNHptPdeVKyxFUMkzaN9XujPg==
X-Received: by 2002:a63:e59:0:b0:374:a169:d558 with SMTP id 25-20020a630e59000000b00374a169d558mr23079040pgo.304.1646170999462;
        Tue, 01 Mar 2022 13:43:19 -0800 (PST)
Received: from localhost.localdomain ([115.195.172.220])
        by smtp.googlemail.com with ESMTPSA id n42-20020a056a000d6a00b004d221c3e021sm17834811pfv.55.2022.03.01.13.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 13:43:18 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, kbuild-all@lists.01.org, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lkp@intel.com, netdev@vger.kernel.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH 1/6] Kbuild: compile kernel with gnu11 std
Date:   Wed,  2 Mar 2022 05:43:12 +0800
Message-Id: <20220301214312.7024-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAHk-=wiuZGzc2UaNVPr6rZnK7buvaQWfadZMcDXavE=MeCXw3g@mail.gmail.com>
References: <CAHk-=wiuZGzc2UaNVPr6rZnK7buvaQWfadZMcDXavE=MeCXw3g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sincerely thank you for your reply. I also look forward to your comments
on other patches, especially PATCH 2/6 which provides new *_inside macros
to make iterator invisiable outside the list_for_each_entry* loop.

Best regards,
--
Xiaomeng Tong
