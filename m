Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA90250805B
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 07:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349509AbiDTFEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 01:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349475AbiDTFEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 01:04:14 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509A125EB9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 22:01:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id s18so1194736ejr.0
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 22:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NpFVcX/rQ4/pDaNkozRjOJ0rrg5LCyeh7gZ9ZrDTO40=;
        b=d3nWhttd5RRkY9ZRXXFek2pXWjALd/FZbysGHwVWyAPSLQsiopcIonJW2Cr+QkIYmS
         tXf8InTOePvpULLpqWk9NvSdrjZXkVGLUTEiJupK+DBUp1E/AfjgJo3hym3kzuFy2ckX
         RrsVBhK7NAdvJWCWZj6yzR9sVU5tAtAKRoFEHKM35cXOvXzsQY+7HZLfJ3QHkOqx52vv
         Ml024GGF6BPU6PQ+AwljljbBBWs06bCzqITbmT76GWIqDt5UWtcBR7hTA7gsLTfEUsZR
         hgLLDRt4C+FOuf/wBrvbHfnPyiCUo04xSjD1KK5G+4nuMKyHhiCcdHWr4i35fSqnCvAj
         hmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NpFVcX/rQ4/pDaNkozRjOJ0rrg5LCyeh7gZ9ZrDTO40=;
        b=pDVPZZEy6NGTswhXEDeAaawjl6GTIC/VojB2/F9TkOPtRTcMI/gdLZWY1bfuNZwv24
         Pxx8iXXat03LOXyRJo91/QLZtfryW9sieIV/XYN1To0x5UDlfN1jC9x3cvq4zm6b6/EL
         i68PC0tyzB9QOlX29qkE0rnSlow/frtIP78JQLPRBgNswLRR9WErYYmyxjyCHByEwdbq
         Xx9bq5QiHdO4+P4z7mgs72Hn9Qbk/AHoQSh8Kyxj4Did/fEvDUBjP7TSV9FXuVvqhnea
         yR8QRC2o0opuyprKixvNXuNxunBApzdcMJ6rRlSDErURxXs4ja0Lnm8EGs4V8gwPlkh5
         J57A==
X-Gm-Message-State: AOAM533kQMdhcX2e+NOQjxooKRWaTRX0W5MVNbbCFzDYHQzF9UatE8kn
        Uxby4huxF+HT+oD/dZHN3UWrDRhwgOT6mT31wBA=
X-Google-Smtp-Source: ABdhPJxo5z09Cj7K/MMsHAxFatlz6zMbXHmRmLITft3p/H0sNoakLV9p3Agenl0JkbOZmKKUmIlyU7ePDG5OKuoEVYU=
X-Received: by 2002:a17:906:36c8:b0:6e7:a66f:766e with SMTP id
 b8-20020a17090636c800b006e7a66f766emr16884096ejc.354.1650430887741; Tue, 19
 Apr 2022 22:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220420045512.GA1289782@jaehee-ThinkPad-X1-Extreme>
In-Reply-To: <20220420045512.GA1289782@jaehee-ThinkPad-X1-Extreme>
From:   Jaehee <jhpark1013@gmail.com>
Date:   Wed, 20 Apr 2022 01:01:16 -0400
Message-ID: <CAA1TwFDXYFm4HaTuka_0ZcdD0BENwbCAGDKF44=_wpP3nTiWpg@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
To:     Outreachy Linux Kernel <outreachy@lists.linux.dev>,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        Jaehee Park <jhpark1013@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I sent two of the same patch by accident. Please ignore this one.


On Wed, Apr 20, 2022 at 12:55 AM Jaehee Park <jhpark1013@gmail.com> wrote:
>
> Add a boilerplate test loop to run all tests in
> vrf_strict_mode_test.sh.
>
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---
>  .../testing/selftests/net/vrf_strict_mode_test.sh  | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> index 865d53c1781c..116ca43381b5 100755
> --- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
> +++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> @@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
>
>  PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
>
> +TESTS="vrf_strict_mode_tests_init vrf_strict_mode_tests_testns vrf_strict_mode_tests_mix"
> +
>  log_test()
>  {
>         local rc=$1
> @@ -391,7 +393,17 @@ fi
>  cleanup &> /dev/null
>
>  setup
> -vrf_strict_mode_tests
> +for t in $TESTS
> +do
> +       case $t in
> +       vrf_strict_mode_tests_init|vrf_strict_mode_init) vrf_strict_mode_tests_init;;
> +       vrf_strict_mode_tests_testns|vrf_strict_mode_testns) vrf_strict_mode_tests_testns;;
> +       vrf_strict_mode_tests_mix|vrf_strict_mode_mix) vrf_strict_mode_tests_mix;;
> +
> +       help) echo "Test names: $TESTS"; exit 0;;
> +
> +       esac
> +done
>  cleanup
>
>  print_log_test_results
> --
> 2.25.1
>
