Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887E7388C1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 13:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfFGLPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 07:15:36 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33115 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFGLPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 07:15:36 -0400
Received: by mail-ed1-f67.google.com with SMTP id h9so2516198edr.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 04:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=InS/9rTjNq41ZqCvmF7N6OSFKsjEARE1rn+5LfhIC0Q=;
        b=gqi1I/B0Dey3+Q3aTlRs16j0hl0A89wbAMRSYlGkTyO1dCzWEcqYL88vNEHvEUcJfI
         EQLSHOPXtqOAvw6DkeapaIBFiImLjK7IZUbLEXrhgbWneDB4nvfwa0rZpKKUnHVLkvtQ
         qHm87Uh2uAPIrbxiLoEMeQxc7PxDqfuQuJZngtktYPKemFBbL/rUw5xc79saw5IU2nwp
         bl/7S+L7WudktPCFBiS+NEP4wx82QvQPwgU8rTF1hDJ3n5IinZ1VA8PjZC5BV59LPJDy
         MmLmslqfF9qABaknOUlBeLDZ4z7QiWVxkO1Lf6s3IUogto69GYWYEtakFA8OeLD+d49k
         MxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=InS/9rTjNq41ZqCvmF7N6OSFKsjEARE1rn+5LfhIC0Q=;
        b=HpNaD/QcZrWAOw07EFDNH0mlrMz7nZh0oGRN4Pmzz7p8eyx1Hra0OaKvkrIpx88M8O
         6SuoT474ETcpxLhLQqaQ6/vh4xQjTy6fySVyhI5DCPW6z/VxkpfLNT1qxzADlVXM27p8
         4m3uYfZ2sTrqxLG1kxuQzWLDOm1GsMU/sinasbDxJdGSGU21bXLUT2SgTJ3jXx7yNVTs
         UY9vE6SLoHdTgH3buIOjt6mz0+baTUKxyww3ppkVTgE3CGOGrQRUJjLS+uemZj35V1cL
         wrwt4ZP9iP9zaN+XNhbphxc795bOVU2pWxPTn+VmYv6mQCA04o3oydm+BP7x2DpYijEX
         g32g==
X-Gm-Message-State: APjAAAWMwwoxHkRsKK0aDJsAj9Yp03I7QGWZWZN7NgA3grd5iSsV3kph
        sWt8zVwXDFucBSb+9qB/L333a8f+OLshX4oppS0=
X-Google-Smtp-Source: APXvYqzG8xMceukdavtmsLZd6YT2T+M8sSwB3Clh7NdQ455tIoW0QXxo9mezCSDJvVns+ILtccWv7EJKjm9NjZp+ThQ=
X-Received: by 2002:a17:906:259a:: with SMTP id m26mr46951952ejb.230.1559906133757;
 Fri, 07 Jun 2019 04:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190603121244.3398-1-idosch@idosch.org> <20190603121244.3398-10-idosch@idosch.org>
In-Reply-To: <20190603121244.3398-10-idosch@idosch.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 7 Jun 2019 14:15:22 +0300
Message-ID: <CA+h21hrAzdb0Bnn4dbJqnqRAhgR-3r+DBEYyEUh=_rk6Jh3ouA@mail.gmail.com>
Subject: Re: [PATCH net-next 9/9] selftests: ptp: Add Physical Hardware Clock test
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 15:25, Ido Schimmel <idosch@idosch.org> wrote:
>
> From: Shalom Toledo <shalomt@mellanox.com>
>
> Test the PTP Physical Hardware Clock functionality using the "phc_ctl" (a
> part of "linuxptp").
>
> The test contains three sub-tests:
>   * "settime" test
>   * "adjtime" test
>   * "adjfreq" test
>
> "settime" test:
>   * set the PHC time to 0 seconds.
>   * wait for 120.5 seconds.
>   * check if PHC time equal to 120.XX seconds.
>
> "adjtime" test:
>   * set the PHC time to 0 seconds.
>   * adjust the time by 10 seconds.
>   * check if PHC time equal to 10.XX seconds.
>
> "adjfreq" test:
>   * adjust the PHC frequency to be 1% faster.
>   * set the PHC time to 0 seconds.
>   * wait for 100.5 seconds.
>   * check if PHC time equal to 101.XX seconds.
>
> Usage:
>   $ ./phc.sh /dev/ptp<X>
>
>   It is possible to run a subset of the tests, for example:
>     * To run only the "settime" test:
>       $ TESTS="settime" ./phc.sh /dev/ptp<X>
>
> Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  tools/testing/selftests/ptp/phc.sh | 166 +++++++++++++++++++++++++++++
>  1 file changed, 166 insertions(+)
>  create mode 100755 tools/testing/selftests/ptp/phc.sh
>
> diff --git a/tools/testing/selftests/ptp/phc.sh b/tools/testing/selftests/ptp/phc.sh
> new file mode 100755
> index 000000000000..ac6e5a6e1d3a
> --- /dev/null
> +++ b/tools/testing/selftests/ptp/phc.sh
> @@ -0,0 +1,166 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +ALL_TESTS="
> +       settime
> +       adjtime
> +       adjfreq
> +"
> +DEV=$1
> +
> +##############################################################################
> +# Sanity checks
> +
> +if [[ "$(id -u)" -ne 0 ]]; then
> +       echo "SKIP: need root privileges"
> +       exit 0
> +fi
> +
> +if [[ "$DEV" == "" ]]; then
> +       echo "SKIP: PTP device not provided"
> +       exit 0
> +fi
> +
> +require_command()
> +{
> +       local cmd=$1; shift
> +
> +       if [[ ! -x "$(command -v "$cmd")" ]]; then
> +               echo "SKIP: $cmd not installed"
> +               exit 1
> +       fi
> +}
> +
> +phc_sanity()
> +{
> +       phc_ctl $DEV get &> /dev/null
> +
> +       if [ $? != 0 ]; then
> +               echo "SKIP: unknown clock $DEV: No such device"
> +               exit 1
> +       fi
> +}
> +
> +require_command phc_ctl
> +phc_sanity
> +
> +##############################################################################
> +# Helpers
> +
> +# Exit status to return at the end. Set in case one of the tests fails.
> +EXIT_STATUS=0
> +# Per-test return value. Clear at the beginning of each test.
> +RET=0
> +
> +check_err()
> +{
> +       local err=$1
> +
> +       if [[ $RET -eq 0 && $err -ne 0 ]]; then
> +               RET=$err
> +       fi
> +}
> +
> +log_test()
> +{
> +       local test_name=$1
> +
> +       if [[ $RET -ne 0 ]]; then
> +               EXIT_STATUS=1
> +               printf "TEST: %-60s  [FAIL]\n" "$test_name"
> +               return 1
> +       fi
> +
> +       printf "TEST: %-60s  [ OK ]\n" "$test_name"
> +       return 0
> +}
> +
> +tests_run()
> +{
> +       local current_test
> +
> +       for current_test in ${TESTS:-$ALL_TESTS}; do
> +               $current_test
> +       done
> +}
> +
> +##############################################################################
> +# Tests
> +
> +settime_do()
> +{
> +       local res
> +
> +       res=$(phc_ctl $DEV set 0 wait 120.5 get 2> /dev/null \
> +               | awk '/clock time is/{print $5}' \
> +               | awk -F. '{print $1}')
> +
> +       (( res == 120 ))
> +}
> +
> +adjtime_do()
> +{
> +       local res
> +
> +       res=$(phc_ctl $DEV set 0 adj 10 get 2> /dev/null \
> +               | awk '/clock time is/{print $5}' \
> +               | awk -F. '{print $1}')
> +
> +       (( res == 10 ))
> +}
> +
> +adjfreq_do()
> +{
> +       local res
> +
> +       # Set the clock to be 1% faster
> +       res=$(phc_ctl $DEV freq 10000000 set 0 wait 100.5 get 2> /dev/null \
> +               | awk '/clock time is/{print $5}' \
> +               | awk -F. '{print $1}')
> +
> +       (( res == 101 ))
> +}
> +
> +##############################################################################
> +
> +cleanup()
> +{
> +       phc_ctl $DEV freq 0.0 &> /dev/null
> +       phc_ctl $DEV set &> /dev/null
> +}
> +
> +settime()
> +{
> +       RET=0
> +
> +       settime_do
> +       check_err $?
> +       log_test "settime"
> +       cleanup
> +}
> +
> +adjtime()
> +{
> +       RET=0
> +
> +       adjtime_do
> +       check_err $?
> +       log_test "adjtime"
> +       cleanup
> +}
> +
> +adjfreq()
> +{
> +       RET=0
> +
> +       adjfreq_do
> +       check_err $?
> +       log_test "adjfreq"
> +       cleanup
> +}
> +
> +trap cleanup EXIT
> +
> +tests_run
> +
> +exit $EXIT_STATUS
> --
> 2.20.1
>

Cool testing framework, thanks!
Some things to consider:
- Why the .5 in the wait commands?
- I suspect there's a huge margin of inaccuracy that the test is
missing by only looking at the 'seconds' portion of the PHC time after
the adjfreq operation (up to 10^9 - 1 ppb, in the worst case).

Tested-by: Vladimir Oltean <olteanv@gmail.com>

Regards,
-Vladimir
