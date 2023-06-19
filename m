Return-Path: <netdev+bounces-11899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A35735081
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27B511C209BF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC14C135;
	Mon, 19 Jun 2023 09:39:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC45EBE6C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:39:23 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122B3AF;
	Mon, 19 Jun 2023 02:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687167561; x=1718703561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FIVpQIzsj4Ssu2XYiw1BeI1GG1jqR889PGXaA6nQNcg=;
  b=D9E4xxsRnFp7Y9yaeeAWwx9c8vmA+eeiKFi8jgSeLJLvui3TsNPX48p7
   HkWo+GfhnTWkY787+fpP1tOHOhzTclx03qr2an1JlxHOtK65Sbz6402uv
   hHBWXg6n/+QjnJHC8VzDzl2qpbbC66OkDWJQ3fYG6+orqKj7EALMwUnHp
   Kejju/18Dc/1tJBCfqY9HzluZqu2HajpiYxAOKlP3cj+l61kPqwgHcaOh
   T9Ed2wEo6DtKm6hNNDPoi67PR9lnnJVNWJbj7xOKVGdrp0hX0CeHt6hlc
   +QYiepxSw8x/aoAzvGsrqPLia48w56bZMq5mYhJ5uDbHY6pb5k2Br81PQ
   g==;
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="230876711"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jun 2023 02:39:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 19 Jun 2023 02:39:16 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 19 Jun 2023 02:39:16 -0700
Date: Mon, 19 Jun 2023 11:39:16 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Alex Maftei <alex.maftei@amd.com>
CC: <richardcochran@gmail.com>, <shuah@kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] selftests/ptp: Add -x option for testing
 PTP_SYS_OFFSET_EXTENDED
Message-ID: <20230619093916.xxfkzj576hwz4tjq@soft-dev3-1>
References: <cover.1686955631.git.alex.maftei@amd.com>
 <e3e14166f0e92065d08a024159e29160b815d2bf.1686955631.git.alex.maftei@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <e3e14166f0e92065d08a024159e29160b815d2bf.1686955631.git.alex.maftei@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/16/2023 23:48, Alex Maftei wrote:

Hi Alex,

As I can see you will need to send another patch, I have just a small
comment bellow.


> The -x option (where 'x' stands for eXtended) takes an argument which
> represents the number of samples to request from the PTP device.
> The help message will display the maximum number of samples allowed.
> Providing an invalid argument will also display the maximum number of
> samples allowed.
> 
> Signed-off-by: Alex Maftei <alex.maftei@amd.com>
> ---
>  tools/testing/selftests/ptp/testptp.c | 42 +++++++++++++++++++++++++--
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
> index cfa9562f3cd8..2a99973ffc1b 100644
> --- a/tools/testing/selftests/ptp/testptp.c
> +++ b/tools/testing/selftests/ptp/testptp.c
> @@ -142,8 +142,9 @@ static void usage(char *progname)
>                 " -S         set the system time from the ptp clock time\n"
>                 " -t val     shift the ptp clock time by 'val' seconds\n"
>                 " -T val     set the ptp clock time to 'val' seconds\n"
> +               " -x val     get an extended ptp clock time with the desired number of samples (up to %d)\n"
>                 " -z         test combinations of rising/falling external time stamp flags\n",
> -               progname);
> +               progname, PTP_MAX_SAMPLES);
>  }
> 
>  int main(int argc, char *argv[])
> @@ -157,6 +158,7 @@ int main(int argc, char *argv[])
>         struct timex tx;
>         struct ptp_clock_time *pct;
>         struct ptp_sys_offset *sysoff;
> +       struct ptp_sys_offset_extended *soe;
> 
>         char *progname;
>         unsigned int i;
> @@ -174,6 +176,7 @@ int main(int argc, char *argv[])
>         int index = 0;
>         int list_pins = 0;
>         int pct_offset = 0;
> +       int getextended = 0;
>         int n_samples = 0;
>         int pin_index = -1, pin_func;
>         int pps = -1;
> @@ -188,7 +191,7 @@ int main(int argc, char *argv[])
> 
>         progname = strrchr(argv[0], '/');
>         progname = progname ? 1+progname : argv[0];
> -       while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:p:P:sSt:T:w:z"))) {
> +       while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:p:P:sSt:T:w:x:Xz"))) {

The 'X' needs to be part of the next patch, as you introduce here only 'x'.

>                 switch (c) {
>                 case 'c':
>                         capabilities = 1;
> @@ -250,6 +253,13 @@ int main(int argc, char *argv[])
>                 case 'w':
>                         pulsewidth = atoi(optarg);
>                         break;
> +               case 'x':
> +                       getextended = atoi(optarg);
> +                       if (getextended < 1 || getextended > PTP_MAX_SAMPLES) {
> +                               fprintf(stderr, "number of extended timestamp samples must be between 1 and %d; was asked for %d\n", PTP_MAX_SAMPLES, getextended);
> +                               return -1;
> +                       }
> +                       break;
>                 case 'z':
>                         flagtest = 1;
>                         break;
> @@ -516,6 +526,34 @@ int main(int argc, char *argv[])
>                 free(sysoff);
>         }
> 
> +       if (getextended) {
> +               soe = calloc(1, sizeof(*soe));
> +               if (!soe) {
> +                       perror("calloc");
> +                       return -1;
> +               }
> +
> +               soe->n_samples = getextended;
> +
> +               if (ioctl(fd, PTP_SYS_OFFSET_EXTENDED, soe))
> +                       perror("PTP_SYS_OFFSET_EXTENDED");
> +               else {
> +                       printf("extended timestamp request returned %d samples\n",
> +                               getextended);
> +
> +                       for (i = 0; i < getextended; i++) {
> +                               printf("sample #%2d: system time before: %lld.%09u\n",
> +                               i, soe->ts[i][0].sec, soe->ts[i][0].nsec);
> +                               printf("            phc time: %lld.%09u\n",
> +                               soe->ts[i][1].sec, soe->ts[i][1].nsec);
> +                               printf("            system time after: %lld.%09u\n",
> +                               soe->ts[i][2].sec, soe->ts[i][2].nsec);
> +                       }
> +               }
> +
> +               free(soe);
> +       }
> +
>         close(fd);
>         return 0;
>  }
> --
> 2.28.0
> 
> 

-- 
/Horatiu

