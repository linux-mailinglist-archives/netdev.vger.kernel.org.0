Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8172D513A65
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345885AbiD1Qxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350372AbiD1Qxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:53:31 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD48369C5
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:50:15 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p18so6211212edr.7
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lBCi16HS8lt1DUU2ZqCqxNzFXhSbfL3w7CctSXMZjg0=;
        b=Md+UgvZ8cxffEMcXxUHhUqKs9BRiH0Bfg1FUoO2mxXCZ4GpyoIi68NZ2SCkFvrBDK8
         l0EVD9SELo1n7N/0IF0PxTIL8MRc5pmMb59rRV/LgHsgmotLggRxxwIk48GdcS8UejxX
         LG2V6doq9zhilGofyUW4KNx3hx1ee7IGwBlRwuG9LHkexnpNg42RCJnX++/M58iCnEr4
         U/8LJOQ+lTY/oB4eZbZs/Nup/22ZqzLtn8kZ6f0T4MNpibCTdCbEgFhqowrKHAQmaMab
         Qun/+yCJg9cB6rcFTZLWrlg6L7KeOGFbHQ+keHpkY1A7qJJrlqPRPjxOF8WutfYEOaS2
         Ex8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lBCi16HS8lt1DUU2ZqCqxNzFXhSbfL3w7CctSXMZjg0=;
        b=FA4358m+trrnVyB+o7rcKVzKZnTsBkZSAcIPNdIXA8wF7baOveFsV003yUAJsO/jUp
         36WnGYGiLGngsnng6WTHGzn82euJHfJNE08IBVvySL7Z2Xpq7MDYHBEbz/EmWt4j4cw3
         A9BPiG8s4OdeYOC5U+BmBIontON0iShGNV4Bpml194Nu2u218f2abrB5RH2FXNefOLeV
         hkIiWlFjvASP8Nfb6MYN8Hm42Lf5qCASw1pdwmjUJVNPnSie5nmfT4okY7JLg37FdUhx
         qQ3D0NYWxl1zUrv0peyFFvLeKbwFM5IVSXQ11hampOd8InRssBvgIAyD0wS7ZWlar/P+
         K38w==
X-Gm-Message-State: AOAM5333dI8gMIS58WPDRyVOgiXV+ifBKtMxI4OfZ1EG3qslFZNi+1Cx
        aWhzCqE1CFHtODFnqF/MfFaxHYFgpsSEBItK+/k=
X-Google-Smtp-Source: ABdhPJwAR1SAV4Q5qt330RNg2nZFevbCIv6bpXDMPAYO1gySiVqzMc61mfXVcpPUCC3TSSltk0xcD911rHrza5CToaQ=
X-Received: by 2002:a05:6402:d51:b0:425:d5e1:e9f0 with SMTP id
 ec17-20020a0564020d5100b00425d5e1e9f0mr28299266edb.125.1651164614226; Thu, 28
 Apr 2022 09:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220421164022.GA3485225@jaehee-ThinkPad-X1-Extreme>
 <c2eb6a8a-531e-7a6e-267c-23577f2e95e8@nvidia.com> <07614827-2527-fc9d-43da-d8a30d987494@gmail.com>
In-Reply-To: <07614827-2527-fc9d-43da-d8a30d987494@gmail.com>
From:   Jaehee <jhpark1013@gmail.com>
Date:   Thu, 28 Apr 2022 12:50:02 -0400
Message-ID: <CAA1TwFD5wfA9oXT1PrbLsootEO_C=PAeytbeQFwj=Go8+gc1CQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
To:     David Ahern <dsahern@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Outreachy Linux Kernel <outreachy@lists.linux.dev>,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 12:29 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/23/22 9:48 PM, Roopa Prabhu wrote:
> >
> > On 4/21/22 09:40, Jaehee Park wrote:
> >> Add a boilerplate test loop to run all tests in
> >> vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
> >> run.
> >>
> >> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> >> ---
> >
> > Thanks Jaehee.
> >
> > CC, David Ahern
> >
> > David, this might be an overkill for this test. But nonetheless a step
> > towards bringing some uniformity in the tests.
> >
> > next step is to ideally move this to a library to remove repeating this
> > boilerplate loop in every test.
> >
> >
> > .../selftests/net/vrf_strict_mode_test.sh | 31 ++++++++++++++++++-
> >
> >>   1 file changed, 30 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh
> >> b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> >> index 865d53c1781c..ca4379265706 100755
> >> --- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
> >> +++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> >> @@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
> >>     PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
> >>   +TESTS="init testns mix"
> >> +
> >>   log_test()
> >>   {
> >>       local rc=$1
> >> @@ -353,6 +355,23 @@ vrf_strict_mode_tests()
> >>       vrf_strict_mode_tests_mix
> >>   }
>
> Add:
>
> ################################################################################
> # usage
>
> >>   +usage()
> >> +{
> >> +    cat <<EOF
> >> +usage: ${0##*/} OPTS
> >> +
> >> +    -t <test> Test(s) to run (default: all)
> >> +          (options: $TESTS)
> >> +EOF
> >> +}
>
> Add:
>
> ################################################################################
> # main
>
> >> +while getopts ":t:h" opt; do
> >> +    case $opt in
> >> +        t) TESTS=$OPTARG;;
> >> +        h) usage; exit 0;;
> >> +        *) usage; exit 1;;
> >> +    esac
> >> +done
> >> +
> >>   vrf_strict_mode_check_support()
> >>   {
> >>       local nsname=$1
> >> @@ -391,7 +410,17 @@ fi
> >>   cleanup &> /dev/null
> >>     setup
> >> -vrf_strict_mode_tests
> >> +for t in $TESTS
> >> +do
> >> +    case $t in
> >> +    vrf_strict_mode_tests_init|init) vrf_strict_mode_tests_init;;
> >> +    vrf_strict_mode_tests_testns|testns) vrf_strict_mode_tests_testns;;
> >> +    vrf_strict_mode_tests_mix|mix) vrf_strict_mode_tests_mix;;
> >> +
> >> +    help) echo "Test names: $TESTS"; exit 0;;
> >> +
> >> +    esac
> >> +done
> >>   cleanup
> >>     print_log_test_results
>
> This change makes vrf_strict_mode_tests unused. Move the log_section
> before the tests in that function to the function handling the test.
> e.g., move 'log_section "VRF strict_mode test on init network
> namespace"' to vrf_strict_mode_tests_init.
>
> Alsom, make sure you are using tabs for indentation vs spaces.

Hi David,

Sorry about the delay in getting these fixes to you and thank you for
your review and comments! I've sent the revised patch just now.

Thanks,
Jaehee
