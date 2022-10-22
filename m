Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9293609042
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJVWRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 18:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJVWRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 18:17:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD6171984
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 15:17:15 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o4so1811718wrq.6
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 15:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:content-language:to:subject:from
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yc47WsTxg4MKVC1BHsizlyWZC4SLRHrGHGODEUqNkN8=;
        b=BfFRlCMqBHkHxmo1AbWUo1UBUIkkgkrGCM9Sy+hchqCiefDJvelv5Hx4e5oJ3WXLzi
         DKVlnwrbwFb1HDuRVNhzyfmPcF2bhTSthCuXVoDgnZK0ImZ+Wjsk9fNq18En2+JbHdUW
         KtNjym3wEOM/j64UPek2bBZqTdDA8Vis3A/pAgJJBHV0WvkvWMjo9pKjaMnQZvCoUe73
         NqQzkaqbMMAfIdHm3e8BioGKUxPvvIQGXKxXHcykulyMXkV/BgRdzNQdAMIZcuaTWx50
         Ig9qYhW+8tOmdR9q6BBP1VW+GJLExy9zritFxajKI8ydbGltpPbx1t/QFprZfXPOP6dI
         GP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:content-language:to:subject:from
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yc47WsTxg4MKVC1BHsizlyWZC4SLRHrGHGODEUqNkN8=;
        b=Dwcj7AoS+Te2s+oQOKm2GgGLCBsHXFPT+vtHRXdHfZKov9IWq2RFA2Vcw9y7NztSAo
         pstnCwxgpd1UEfM1dPj/0GFLwadtuDqI3waN0xbC5l4wYnkGkXJnKrl/xgGctQ+lDNIE
         nZgtxWuUm/8qWEcd304moNpn6jNJNCmbZomhn/2xtapnNHfCcZ86JHhb/SBdTRgvCooY
         x788+6xMiQbCGnjPFLVpYfwCZGUWfBzIHt6w5J/UyRIzqIoQ9ewkJtmcvd9h560zH+H9
         EMlnPFwP8/tHre+nqYeHHwYhd46fJt9nST1VUdVIAMkNDlH5sDmsauAsyHKoz2LEjAeY
         5agw==
X-Gm-Message-State: ACrzQf3L+ZQunbIpar5aEsqhdl+ctyEPy7xIh4IR8XQkXwiE70v6iEKr
        gyTF025pXo8/rKW6AMu8Lg==
X-Google-Smtp-Source: AMsMyM7sReouS9gQMprcbWt8x/b44ugSLNRuU++qIZpvB7Ntn9bySQN9BuRearkFLGE+afUjuaFjyg==
X-Received: by 2002:a05:6000:1c18:b0:232:a0fb:efe1 with SMTP id ba24-20020a0560001c1800b00232a0fbefe1mr16477873wrb.459.1666477033371;
        Sat, 22 Oct 2022 15:17:13 -0700 (PDT)
Received: from localhost (18.red-81-44-141.dynamicip.rima-tde.net. [81.44.141.18])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c35c900b003c5571c27a1sm8943553wmq.32.2022.10.22.15.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 15:17:12 -0700 (PDT)
Message-ID: <4f4d4ddb-62c7-d073-91d1-2dbb9127b8fa@gmail.com>
Date:   Sun, 23 Oct 2022 00:17:12 +0200
MIME-Version: 1.0
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: ethtool: missing ETHTOOL_LINK_MODE_10baseT1L_Full_BIT
To:     Alexandru Tachici <alexandru.tachici@analog.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Language: en-US
Cc:     NETDEV ML <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


It was defined in the kernel: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3254e0b9eb5649ffaa48717ebc9c593adc4ee6a9
but missing in ethtool.


Thank you.
