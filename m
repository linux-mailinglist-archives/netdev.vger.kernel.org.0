Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D4850A621
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiDUQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiDUQu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:50:27 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6054926C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:47:37 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id o18so3697164qtk.7
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G5SKEdGOaIvfBQJSpHuJhVtB76TixYdqOy3GhFLhSCI=;
        b=iq91iNJMVttXcdpXrr+XHPWB6kmqqiyKEa4gAGrR42RnnX4fKXop4+0lZMODXP1zTX
         kaxLFLpc67MqD3U/UOMLaHv78A4lumTAyew/jObqEuIlN53rCcSeNzG2f2G/DX4RjIPH
         46G03V0Jpi+K1I1Y+oketj0FCYJHq8n7jixJAGJO24+LIWYYigA3US7NAlART7REqcff
         47nv6DE9U2vqEuEBuxCgyvTzD6xRG/XDAeq+62Q6FTJcIQ32nN2jaGRm2otdYB9uitrf
         sIpWlMHJty1YQ/0itXkoMseuDDV17fVEezE4X3f+1A7XRXR+HdyYSSHu3A0tj7KkihrK
         3d9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G5SKEdGOaIvfBQJSpHuJhVtB76TixYdqOy3GhFLhSCI=;
        b=aoNS8t3XJ0LigFE5qb2lL++T4RBmS88E6Y8iegqrHxuHllW3p2rMJ3ZqO9zEuDC6tk
         n6uVWZcj2tVCxrvoidzs05pAA6h4PPQiVrpibCnFlBz9tdYeiZhcLUXyVOd25mzNUEQS
         XFo2zXyyQFnTCmvczFEH7aY3mMLSY8p/Z7MzcQJWiBz0qx5okKjX/1g7LuIRibQ7jOWT
         xV/NABmMAVoU1T1dMpFrfB8KHUpd0Zxbho5MPmzypbm7Ha4yo1ZFkh1jrt0M7WJXtSD4
         7LU9YlNkF7gmgX8s3e7LC1ksC0B1zuKUdQ51m8W9dnkN9akhD0GWec3wmb/5un8m5nPF
         q6xA==
X-Gm-Message-State: AOAM531sLBYhvj9RqUdUECsrmi9kcBYZLRdPrv1pCzxKg87DSOSXNaLa
        d5GLkvQkwIVsYXC8Lyt1T2I=
X-Google-Smtp-Source: ABdhPJywgbZ4z65uj2wmxLheHMk9axyMGU3bKRCMtfyY/HwTMX3ZJmcojZ77NU2zSMPkgp0ueyOaNg==
X-Received: by 2002:a05:622a:1990:b0:2f3:3eb7:33e9 with SMTP id u16-20020a05622a199000b002f33eb733e9mr275676qtc.13.1650559656314;
        Thu, 21 Apr 2022 09:47:36 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([4.34.18.218])
        by smtp.gmail.com with ESMTPSA id d17-20020ac85d91000000b002f3359b32c2sm3975173qtx.78.2022.04.21.09.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:47:35 -0700 (PDT)
Date:   Thu, 21 Apr 2022 12:47:31 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     outreachy@lists.linux.dev, Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Message-ID: <20220421164731.GA3485444@jaehee-ThinkPad-X1-Extreme>
References: <20220420045512.GA1289782@jaehee-ThinkPad-X1-Extreme>
 <41a48002-817b-4366-d316-9d94e8d81a79@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41a48002-817b-4366-d316-9d94e8d81a79@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 07:52:45AM -0700, Roopa Prabhu wrote:
> 
> On 4/19/22 21:55, Jaehee Park wrote:
> > Add a boilerplate test loop to run all tests in
> > vrf_strict_mode_test.sh.
> > 
> > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> > ---
> 
> Jaehee, this needs more work. The idea is to be able to run individual tests
> with -t option.
> 
> An example is drop_monitor_tests.sh, see the usage and getopts arg parsing
> at the beginning of the test
> 
> eg ./drop_monitor_tests.sh -t <testname>
> 
> 

Thanks Roopa, I've sent version 2 for your review. 


> >   .../testing/selftests/net/vrf_strict_mode_test.sh  | 14 +++++++++++++-
> >   1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> > index 865d53c1781c..116ca43381b5 100755
> > --- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
> > +++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> > @@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
> >   PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
> > +TESTS="vrf_strict_mode_tests_init vrf_strict_mode_tests_testns vrf_strict_mode_tests_mix"
> > +
> >   log_test()
> >   {
> >   	local rc=$1
> > @@ -391,7 +393,17 @@ fi
> >   cleanup &> /dev/null
> >   setup
> > -vrf_strict_mode_tests
> > +for t in $TESTS
> > +do
> > +	case $t in
> > +	vrf_strict_mode_tests_init|vrf_strict_mode_init) vrf_strict_mode_tests_init;;
> > +	vrf_strict_mode_tests_testns|vrf_strict_mode_testns) vrf_strict_mode_tests_testns;;
> > +	vrf_strict_mode_tests_mix|vrf_strict_mode_mix) vrf_strict_mode_tests_mix;;
> > +
> > +	help) echo "Test names: $TESTS"; exit 0;;
> > +
> > +	esac
> > +done
> >   cleanup
> >   print_log_test_results
