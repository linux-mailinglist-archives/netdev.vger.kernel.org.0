Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9B639EF0
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 02:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiK1BbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 20:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiK1Ba7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 20:30:59 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCEFA45A
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 17:30:58 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h193so8612446pgc.10
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 17:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ivan-computer.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eHIyETS1lGz31szWszpuBGcrsTyrBOqWhdPJ/l2FVS4=;
        b=1JJpTxD0a8aytT36HRDIfBru8y7OZTgRm7PdgOY6gy6PD9GHFELU72jGFjGO6J8/kw
         WhlyYzlRl6m64T6QyYofo+twwOtHP81UTpLgy75ULc24232lclKbTKSJD9HmgGOPQc63
         LmsM6Vdr52hNYo/fa8YKM+iiawOkUb3XBjY6OhYUUqpHIc+apRKCuy//mUV8EVdPEHvX
         qLsU6rezwssHrptLb12nUWOdXxSY6T+Cv8q200y+CE760/d6KIJwDSHaCPUQxLYXNkog
         5LaxLPIqZNfXJlQmG9GCGhFTWCLF4JUOdqC5SaAKbMR5JCXeCzPk4DjAKljJ0q6zME7k
         5gJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eHIyETS1lGz31szWszpuBGcrsTyrBOqWhdPJ/l2FVS4=;
        b=TFMVzgmvUc3R7BXJkjU/v1IuxQN5KkRlDNN69jops/lllNHBVlS/6pnPiMqRMEW30J
         TnLoBb08odEoM9gJQKWBIoI1ECLTeoXBsYfEGj72don6vjURHqtCPBMdsd3E/rT4KtS1
         DRSA0DeNVSMpfAV0SVudkU+Lc7e/t0DW0gBZ8miA99F9jOTdQjT+zkoC3p/yNg/OFtpe
         nNNaUxZA0lEoqYG22x+Guul/FQgtT8ejW45WFQqgRhy6L01WJ4qfdEdFIvptPFg4Edis
         lTRhlz05GNP/u+A8SFm717oiQhL0VE2BKX0HsFTH0Z6TTPX0ivbH6YKOBoV1HRh7sn5A
         ymkA==
X-Gm-Message-State: ANoB5pk9RUp/ExiO8NU1XdUO99ERjWSNc8H2Ia8TJDTVmhUA/bHtIUv+
        4kCxjAOAI/BEp71P2EnyNH0lZsIDPdM5yHYVvOK3Xg==
X-Google-Smtp-Source: AA0mqf6/JW8PVKHVn7ofjb3WyFOOg3d21aAJavoE3qpWPyW9xVpOJBxXwPoo2t3hWlFKdWazS4gNx67OkGhaUYPhN2o=
X-Received: by 2002:a62:ea0e:0:b0:575:7bb:d6fc with SMTP id
 t14-20020a62ea0e000000b0057507bbd6fcmr6245800pfh.79.1669599057711; Sun, 27
 Nov 2022 17:30:57 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@ivan.computer>
Date:   Sun, 27 Nov 2022 17:30:47 -0800
Message-ID: <CAGjnhw_2oSWfMjNPZMneJXxdvT+qoqhKV8787NYuHnOauhSVyw@mail.gmail.com>
Subject: Unused variable 'mark' in v6.1-rc7
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's 52d1aa8b8249 in v6.1-rc7:

* netfilter: conntrack: Fix data-races around ct mark

It triggers an error:

#19 355.8 /build/linux-source/net/netfilter/nf_conntrack_netlink.c: In
function '__ctnetlink_glue_build':
#19 355.8 /build/linux-source/net/netfilter/nf_conntrack_netlink.c:2674:13:
error: unused variable 'mark' [-Werror=unused-variable]
#19 355.8  2674 |         u32 mark;
#19 355.8       |             ^~~~
#19 355.8 cc1: all warnings being treated as errors

If CONFIG_NF_CONNTRACK_MARK is not enabled, as mark is declared
unconditionally, but used under ifdef:

 #ifdef CONFIG_NF_CONNTRACK_MARK
-       if ((events & (1 << IPCT_MARK) || ct->mark)
-           && ctnetlink_dump_mark(skb, ct) < 0)
+       mark = READ_ONCE(ct->mark);
+       if ((events & (1 << IPCT_MARK) || mark) &&
+           ctnetlink_dump_mark(skb, mark) < 0)
                goto nla_put_failure;
 #endif

To have NF_CONNTRACK_MARK one needs NETFILTER_ADVANCED:

config NF_CONNTRACK_MARK
        bool  'Connection mark tracking support'
        depends on NETFILTER_ADVANCED

It's supposed to be enabled by default:

config NETFILTER_ADVANCED
        bool "Advanced netfilter configuration"
        depends on NETFILTER
        default y

But it's not in defconfig (it's missing from arm64 completely):

$ rg NETFILTER_ADVANCED arch/x86/configs/x86_64_defconfig
93:# CONFIG_NETFILTER_ADVANCED is not set

I think the solution is to enclose mark definition into ifdef as well
and I'm happy to send a patch if you agree and would like me to.
