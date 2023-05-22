Return-Path: <netdev+bounces-4367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C01A70C395
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEAF41C20B95
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B62134B0;
	Mon, 22 May 2023 16:37:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D726AD309
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 16:37:21 +0000 (UTC)
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB23F4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684773440; x=1716309440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MWcmrcB45+IHaicVwnQG8B7kjVe6Xdldd0RzeA16tv0=;
  b=kAh/dBcmczTQbNEKf8pQZHy9W6H5n4mpqDawtsPZ2ZPU097V88YWoaXU
   YOAt5/jkx1eWMglbfDmqvwstGLJLY6iz7ii1yfTT7TQaXIsbSXV/Nirr0
   6C9yrR58bVL7ZsiQy17sspGz478DRRddkSLw4/kT6dUfkDL/pAOmZTLeb
   Y=;
X-IronPort-AV: E=Sophos;i="6.00,184,1681171200"; 
   d="scan'208";a="215574326"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:37:17 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com (Postfix) with ESMTPS id 709DE160A80;
	Mon, 22 May 2023 16:37:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 16:37:16 +0000
Received: from 88665a182662.ant.amazon.com (10.119.123.82) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 16:37:13 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <dario.binacchi@amarulasolutions.com>
CC: <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
	<sudheer.mogilappagari@intel.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH ethtool 1/1] netlink/rss: move variable declaration out of the for loop
Date: Mon, 22 May 2023 09:37:06 -0700
Message-ID: <20230522163706.51863-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230522161710.1223759-1-dario.binacchi@amarulasolutions.com>
References: <20230522161710.1223759-1-dario.binacchi@amarulasolutions.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.123.82]
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date: Mon, 22 May 2023 18:17:10 +0200
> The patch fixes this compilation error:
> 
> netlink/rss.c: In function 'rss_reply_cb':
> netlink/rss.c:166:3: error: 'for' loop initial declarations are only allowed in C99 mode
>    for (unsigned int i = 0; i < get_count(hash_funcs); i++) {
>    ^
> netlink/rss.c:166:3: note: use option -std=c99 or -std=gnu99 to compile your code
> 
> The project doesn't really need a C99 compiler, so let's move the variable
> declaration outside the for loop.
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
>  netlink/rss.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/netlink/rss.c b/netlink/rss.c
> index 4ad6065ef698..a4a72e83fcf0 100644
> --- a/netlink/rss.c
> +++ b/netlink/rss.c
> @@ -92,7 +92,7 @@ int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  	u8 *hkey = NULL;
>  	bool silent;
>  	int err_ret;
> -	int ret;
> +	int i, ret;

'i' was 'unsigned int' and get_count() returns unsigned int.


>  
>  	silent = nlctx->is_dump || nlctx->is_monitor;
>  	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
> @@ -163,7 +163,7 @@ int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  			printf("    Operation not supported\n");
>  			return 0;
>  		}
> -		for (unsigned int i = 0; i < get_count(hash_funcs); i++) {
> +		for (i = 0; i < get_count(hash_funcs); i++) {
>  			printf("    %s: %s\n", get_string(hash_funcs, i),
>  			       (rss_hfunc & (1 << i)) ? "on" : "off");
>  		}
> -- 
> 2.32.0

