Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711C26DE1CB
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjDKRBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjDKRBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:01:19 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDF15FE1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:00:53 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id z13so8147022vss.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681232452;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tTnNjr1uayn9DfHicnDiCohK9FF3VkcIZ2I9QDxxN9s=;
        b=ik88FVzdB/fLlZubiEFP1pinVCx6zFqLOt1NAX/LS7ITfx+fD9hceBtilIDfPFJzPM
         rMJROSFsu2VAKTSu4yl2nM8mQApcHD5Fi6+BxPRfinbKSFsLKNAupsyi2ISzQguCePxR
         GWcDOe9D6QOMTQS+wwpMk8Pbk4iYi/VS4BK7rm1u1GJNF0J3Mx3Mtf8MLpxP2nRrxLU9
         uGVlBvuQvJS3TgjD+vWaege44pnwxBDj4OfzLYLSpVKxazcneKw1UVWgBYVsF7Csig0q
         q1Pws7U0X3tiQGQTSIn4wWvpSINAgbumFGBeO7zgDw3VdhPVv/nlQtzNaPmNZIAJB+aD
         0lng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681232452;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tTnNjr1uayn9DfHicnDiCohK9FF3VkcIZ2I9QDxxN9s=;
        b=NAoWI0ZFUB7VErGn9YdtqQ/95kZeTJh43tMQ+/wTqHQ3Nyr+IslYYLm0ZOdcbeBP/E
         Nk5dPMIZH68LVgi2aWaJF8/fHW9zmNvzWX/5tubKwu3m0QdxpRD1NUQsOZvOOOHSzHTW
         9qUnfRThcpqcyOE3AIwXq5zCR9TExM76chsLv4uV+omt+zK+yzGxWhYldu/XNvkuDJI9
         L7PUbzWi+H8VxmxQlpK+aBAK3IEg1nM+e1jtJj1oZWTm1bCMENoQYFQrREf/Zi9rYVvh
         bZRgFpfn0ywnBFuUY5c31WEVsTYVmfmDf3ROo7O6FoSAl8sW7BrGJmq93F4yWhujtIav
         RoIA==
X-Gm-Message-State: AAQBX9d1Xs8TkXzLjioybHTcAzj0njr8HZ3NAtFN770eCZPjKLctVvQb
        wkNssdkyfg6ZEpj3bbzrstVRbF2uqSFiyspn/YEHVZxAmV2orai9pxk=
X-Google-Smtp-Source: AKy350YP5rmR9IrAZnEnf2OiQvArlRdvsAAYeUyys2gI81ewlVtz9CU7z3Z0IN55k5+QIepQBvkZ3WFhBebQoc41Ljw=
X-Received: by 2002:a05:6102:4747:b0:42c:77e2:37f with SMTP id
 ej7-20020a056102474700b0042c77e2037fmr3340753vsb.1.1681232451954; Tue, 11 Apr
 2023 10:00:51 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Apr 2023 22:30:40 +0530
Message-ID: <CA+G9fYuogkamdKf9+uwsvKh67NGTjZru3feRVyHhEQPhpqipVg@mail.gmail.com>
Subject: selftests: net: sctp_vrf.sh: # sysctl: error: 'net.sctp/l3mdev_accept'
 is an unknown key
To:     Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Xin Long <lucien.xin@gmail.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The selftests net sctp_vrf.sh test case failed due to following errors.
Do you see these errors / warnings at your end ?

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

# selftests: net: sctp_vrf.sh
# modprobe: FATAL: Module sctp not found in directory /lib/modules/6.3.0-rc6
# modprobe: FATAL: Module sctp_diag not found in directory
/lib/modules/6.3.0-rc6
[ 2932.967517] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
[ 2933.005205] IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready
[ 2933.012081] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
# Testing For SCTP VRF:
# sysctl: error: 'net.sctp/l3mdev_accept' is an unknown key
# TEST 01: nobind, connect from client 1, l3mdev_accept=1, Y [
2933.314163] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
exec of \"pkill\" failed: No such file or directory
# [FAIL]
# exec of \"pkill\" failed: No such file or directory
not ok 84 selftests: net: sctp_vrf.sh # exit=3

details:
https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.3-rc6-16-g0d3eb744aed4/testrun/16161555/suite/kselftest-net/test/net_sctp_vrf_sh/details/
https://lkft.validation.linaro.org/scheduler/job/6339612#L8152


metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
  git_sha: 0d3eb744aed40ffce820cded61d7eac515199165
  git_describe: v6.3-rc6-16-g0d3eb744aed4
  kernel_version: 6.3.0-rc6
  kernel-config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2OFj2KfCWPidsBVVNqWRhWTxZMD/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline/-/pipelines/833052206
  artifact-location:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2OFj2KfCWPidsBVVNqWRhWTxZMD/
  toolchain: gcc-11


--
Linaro LKFT
https://lkft.linaro.org
