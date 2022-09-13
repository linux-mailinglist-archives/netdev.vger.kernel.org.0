Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57275B79B4
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiIMSgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiIMSf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:35:58 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51F0FF7
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 10:58:29 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1280590722dso34320516fac.1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 10:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=aaNSjGzXhkohc6W2mTDFVgJmx/qcTzuCH14ahIku08Q=;
        b=b7pgvtF1JtUFn5bp8CblPf6xgylOdA7T3perJnk5Q6cfACJshrDbnvadetUZK+IHJX
         1L5TUvCRz0oSNydaawjA06b1WFPXNBV/W1qVMQ4/0C9n5PW/6tFcnSCXoGP5YgJbX8gj
         A4Fi1Np8K+LOGggS3dSODtGJBmR3Buzds3/ZRdBAnjsRDrYcD/k+MTgDa4zgu43xDETe
         3lVe8SFhd/zCFwzKmGA9VqHSKvL69zhf3wPX1NXkEVug6yUk+SuAyiWu8Vrlg6pEYSzW
         1lQGUtAipGsE2KhOMBVVwtb58QFX7aU6uDxz6QnYjzJaRtxiyoqEuP5/+iZ0RsGGN2X9
         lLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aaNSjGzXhkohc6W2mTDFVgJmx/qcTzuCH14ahIku08Q=;
        b=xN9HdjEHNWOPyyrZsIAe8c/xlLApJ/3PfIHjPUU6PzE4ZDlSl6YcgthzLG9UzGb10a
         8pX1F1rAnHFr8gntaaCGtf/DJ8zu6Ocp3ESwkFzAROcikQu377StLhhSXg/HomfNbN17
         YqhhmVIikTBQcGgJZLqSb67E06u7vtTWfPyn5GOYV0+/DF8StOCVe70yKW/Or9/cALX/
         prKNMZSIp5ZCl7v7jmCg9Z4DxmR6Car5MSShIKlYkBQd9Ab5EIuYJ4Xe8GCr2kLfG04w
         5SHGMetlULfzOct46JP4M/3xKczEcH/lhysLCCprcP+RSvitTK6trSlHD6o6Zn0zpDrI
         HOTQ==
X-Gm-Message-State: ACgBeo0s9Dil6sOdwhpVni5GW7x4xxrwtgs8xtUKXTdWXa5qufbB2qlT
        4atUTDTHAeVBpsW6KlcAxxD0ftpxHz73z+nNMsdT0wqCRj8+GQ==
X-Google-Smtp-Source: AA6agR5VpOn9d0FVybpX9E/+sqIIHUUH30By06vJRG2inDVxVEuixCPiW5+j0Nu8UM9Yg6pXTDNrK1hPqiXxa8UPTIc=
X-Received: by 2002:a05:6808:1491:b0:343:7543:1a37 with SMTP id
 e17-20020a056808149100b0034375431a37mr252213oiw.106.1663091909198; Tue, 13
 Sep 2022 10:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220909012936.268433-1-shaozhengchao@huawei.com> <6d627826-94ac-6c44-9a26-2e2662b58ee0@mojatatu.com>
In-Reply-To: <6d627826-94ac-6c44-9a26-2e2662b58ee0@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 13 Sep 2022 13:58:18 -0400
Message-ID: <CAM0EoMkE9vhMOHohCr-0H0ThH0o++4PTSNnaNbx18tYtnjikVg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8] add tc-testing test cases
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 4:04 PM Victor Nogueira <victor@mojatatu.com> wrote:
>
> > For this patchset, test cases of the ctinfo, gate, and xt action modules
> > are added to the tc-testing test suite. Also add deleting test for
> > connmark, ife, nat, sample and tunnel_key action modules.
> >
> > Zhengchao Shao (8):
> >    selftests/tc-testings: add selftests for ctinfo action
> >    selftests/tc-testings: add selftests for gate action
> >    selftests/tc-testings: add selftests for xt action
> >    selftests/tc-testings: add connmark action deleting test case
> >    selftests/tc-testings: add ife action deleting test case
> >    selftests/tc-testings: add nat action deleting test case
> >    selftests/tc-testings: add sample action deleting test case
> >    selftests/tc-testings: add tunnel_key action deleting test case
> >
> >   .../tc-testing/tc-tests/actions/connmark.json |  50 +++
> >   .../tc-testing/tc-tests/actions/ctinfo.json   | 316 ++++++++++++++++++
> >   .../tc-testing/tc-tests/actions/gate.json     | 315 +++++++++++++++++
> >   .../tc-testing/tc-tests/actions/ife.json      |  50 +++
> >   .../tc-testing/tc-tests/actions/nat.json      |  50 +++
> >   .../tc-testing/tc-tests/actions/sample.json   |  50 +++
> >   .../tc-tests/actions/tunnel_key.json          |  50 +++
> >   .../tc-testing/tc-tests/actions/xt.json       | 219 ++++++++++++
> >   8 files changed, 1100 insertions(+)
> >   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/ctinfo.json
> >   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/gate.json
> >   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/xt.json
> >
>
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>

For this patchset:
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
