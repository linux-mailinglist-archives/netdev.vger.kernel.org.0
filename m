Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10EF2B67BC
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgKQOqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbgKQOqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:46:24 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9726CC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 06:46:23 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id k27so2389949ejs.10
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 06:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUFmOPi5skT4JC7mVv7TNvucfOIONF/gHEhYfaXJH1M=;
        b=NoKA3kUONbuZIUgKOVWKS8dCL1VZkpljGtCtauLbsLBIiUIdEb/ELujIJbi17fgBut
         vybuW15lEfuNRrz9hynfcYE/kTBUCDJwarB3qbn3VzCdU8yI+JsQzbjoWofwwiosmFCB
         W1MlYpKoPdoAY74fxK/Hr/qSkI6e6ha3RMSbB87O7ashYzPwMIKwAuOaA1klC2iEDcpT
         ohm8sCpWVF0ICVPkIJX05VRldFuMBJXYVsWUsMXtsAPsLYxuO/OI4bBKGwQyHAq5OiNd
         19HK6AOGS5BZfotpWGVYIdg5scp9aDp8wfnXNgKY7lDnRxEgah3/oREu5H3Hp7IZUhl+
         +RdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUFmOPi5skT4JC7mVv7TNvucfOIONF/gHEhYfaXJH1M=;
        b=HXC8TgsLF+T8nrwDMGrNyh8bQRSuzRsZE/v+L2LCxhQZW0CSFadaksykk9FTVpmLax
         /Z8EtN0vXtJ9XReMAfmmCQ1PSZMhd2mGdiGixMknM2IX0HVE5YtFYyKZvpr2QNPQuJxw
         Qq+7JpnX43X2CBZdtpLf+Kr/rymgCo0hNgDu4HV0L6khjYRZBUE1p5M0Cgh1/wSjNYId
         lRfY0YCRRIIH0fV/PhiAxY6m8R8uXSlrePvO+s7R5bS5R9ZRtsMlTMql7FC/x92LRm/7
         YJBz+WI+6oHRkWM8Pqhc+9O5nmppaiHN4fZudqD0SD/G27+sUxOXFtWWxHo2+o2L93/H
         lXag==
X-Gm-Message-State: AOAM533O8cmUot6hBCxAJgHdVSdZzkH67+2A+1E+6SmVJZDJuGi5AlSY
        blVDm9Fudt33TLZouTNa4IHg3PwYEO8hvMDnQrdNZg==
X-Google-Smtp-Source: ABdhPJyiVkfHFhAAxAZZiTRGrwjQmEDbhgKr2ktKTE/BN7GVBW6gFKGf4Ui6WDTgcMVMKb60A5idBUeCBH2o+kgOpI4=
X-Received: by 2002:a17:906:f247:: with SMTP id gy7mr19805291ejb.48.1605624382219;
 Tue, 17 Nov 2020 06:46:22 -0800 (PST)
MIME-Version: 1.0
References: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org> <1605566782-38013-6-git-send-email-hemantk@codeaurora.org>
In-Reply-To: <1605566782-38013-6-git-send-email-hemantk@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 17 Nov 2020 15:52:25 +0100
Message-ID: <CAMZdPi_yFtEtquGpfAUh0ULL8bFdDGuoHrpt1EHFz+puGu1T2A@mail.gmail.com>
Subject: Re: [PATCH v12 5/5] selftest: mhi: Add support to test MHI LOOPBACK channel
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 at 23:46, Hemant Kumar <hemantk@codeaurora.org> wrote:
>
> Loopback test opens the MHI device file node and writes
> a data buffer to it. MHI UCI kernel space driver copies
> the data and sends it to MHI uplink (Tx) LOOPBACK channel.
> MHI device loops back the same data to MHI downlink (Rx)
> LOOPBACK channel. This data is read by test application
> and compared against the data sent. Test passes if data
> buffer matches between Tx and Rx. Test application performs
> open(), poll(), write(), read() and close() file operations.
>
> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> ---
>  Documentation/mhi/uci.rst                          |  32 +
>  tools/testing/selftests/Makefile                   |   1 +
>  tools/testing/selftests/drivers/.gitignore         |   1 +
>  tools/testing/selftests/drivers/mhi/Makefile       |   8 +
>  tools/testing/selftests/drivers/mhi/config         |   2 +
>  .../testing/selftests/drivers/mhi/loopback_test.c  | 802 +++++++++++++++++++++
>  6 files changed, 846 insertions(+)
>  create mode 100644 tools/testing/selftests/drivers/mhi/Makefile
>  create mode 100644 tools/testing/selftests/drivers/mhi/config
>  create mode 100644 tools/testing/selftests/drivers/mhi/loopback_test.c
>
> diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
> index ce8740e..0a04afe 100644
> --- a/Documentation/mhi/uci.rst
> +++ b/Documentation/mhi/uci.rst
> @@ -79,6 +79,38 @@ MHI client driver performs read operation, same data gets looped back to MHI
>  host using LOOPBACK channel 1. LOOPBACK channel is used to verify data path
>  and data integrity between MHI Host and MHI device.
>
> +Loopback Test
> +~~~~~~~~~~~~~
> +
> +Loopback test application is used to verify data integrity between MHI host and
> +MHI device over LOOPBACK channel. This also confirms that basic MHI data path
> +is working properly. Test performs write() to send tx buffer to MHI device file
> +node for LOOPBACK uplink channel. MHI LOOPBACK downlink channel loops back
> +transmit data to MHI Host. Test application receives data in receive buffer as
> +part of read(). It verifies if tx buffer matches rx buffer. Test application
> +performs poll() before making write() and read() system calls. Test passes if
> +match is found.
> +
> +Test is present under tools/testing/selftests/drivers/mhi. It is compiled using
> +following command in same dir:-
> +
> +make loopback_test
> +
> +Test is run using following command arguments:-
> +
> +loopback_test -c <device_node> -b <transmit buffer size> -l <log level> -i
> +<number of iterations>
> +
> +Required argument:
> +-c : loopback chardev node
> +
> +Optional argument:
> +-b : transmit buffer size. If not present 1024 bytes size transmit buffer
> +     is sent.
> +-i : Number of iterations to perform, If not present only one transmit buffer
> +     is sent.
> +-l : Log level. If not present defaults to DBG_LVL_INFO.
> +
>  Other Use Cases
>  ---------------
>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index d9c2835..084bc1e 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -10,6 +10,7 @@ TARGETS += core
>  TARGETS += cpufreq
>  TARGETS += cpu-hotplug
>  TARGETS += drivers/dma-buf
> +TARGETS += drivers/mhi
>  TARGETS += efivarfs
>  TARGETS += exec
>  TARGETS += filesystems
> diff --git a/tools/testing/selftests/drivers/.gitignore b/tools/testing/selftests/drivers/.gitignore
> index ca74f2e..e4806d5 100644
> --- a/tools/testing/selftests/drivers/.gitignore
> +++ b/tools/testing/selftests/drivers/.gitignore
> @@ -1,2 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /dma-buf/udmabuf
> +/mhi/loopback_test
> diff --git a/tools/testing/selftests/drivers/mhi/Makefile b/tools/testing/selftests/drivers/mhi/Makefile
> new file mode 100644
> index 0000000..c06c925
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/mhi/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +CFLAGS += -I../../../../../usr/include/ -g -Wall
> +
> +LDLIBS = -lpthread
> +TEST_GEN_PROGS := loopback_test
> +
> +include ../../lib.mk
> +
> diff --git a/tools/testing/selftests/drivers/mhi/config b/tools/testing/selftests/drivers/mhi/config
> new file mode 100644
> index 0000000..471dc92
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/mhi/config
> @@ -0,0 +1,2 @@
> +CONFIG_MHI_BUS=y
> +CONFIG_MHi_UCI=y

CONFIG_MHI_UCI

> diff --git a/tools/testing/selftests/drivers/mhi/loopback_test.c b/tools/testing/selftests/drivers/mhi/loopback_test.c
> new file mode 100644
> index 0000000..99b7712
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/mhi/loopback_test.c
> @@ -0,0 +1,802 @@
> +// SPDX-License-Identifier: GPL-2.0

[...]
