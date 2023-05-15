Return-Path: <netdev+bounces-2643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B9C702CAE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F11B1C20967
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C27C8D9;
	Mon, 15 May 2023 12:28:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0FEC8CB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:28:29 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD4D19C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:28:26 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20230515122821euoutp018eafbb9c7bc9f93f58b9254e9a661663~fUN5QjceJ0921709217euoutp01Z
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:28:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20230515122821euoutp018eafbb9c7bc9f93f58b9254e9a661663~fUN5QjceJ0921709217euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1684153701;
	bh=Svt2kcOt0Htvjg5v2L88wKHwZB8Oh+9PN5UZBQ/SeY8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=VKwmgnaiozHtQcO2eHvlvCwKWRXa6D/5TqGWaydtGhBwhV1DKNZRDNNVO7wcw5OHo
	 /AUQTRUkvMu2nGk2MztKpqvVWGCrtMKfvZzYFSYzvQbLQ9fU6TyxOlA18No/hOysNm
	 7zphFWRvhVQTbWNpf+f1ApcqwQ7Ufm/mRWNHRkrk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230515122821eucas1p1b691338e73e541c7514cbc8e5a6454ce~fUN44l_9U1210812108eucas1p1s;
	Mon, 15 May 2023 12:28:21 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 8D.AE.37758.46522646; Mon, 15
	May 2023 13:28:20 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20230515122820eucas1p1161474cf6453672c92ad076c85446a65~fUN4kECuE1199511995eucas1p1H;
	Mon, 15 May 2023 12:28:20 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230515122820eusmtrp12f7ca4a4706d781e6f2d380c6f7d626e~fUN4jdh1W2646926469eusmtrp1b;
	Mon, 15 May 2023 12:28:20 +0000 (GMT)
X-AuditID: cbfec7f5-7ffff7000002937e-5f-646225642b59
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id C3.1F.10549.46522646; Mon, 15
	May 2023 13:28:20 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230515122820eusmtip26e3526db41f2afa5764546e0972eac98~fUN4CUJ6g1302613026eusmtip23;
	Mon, 15 May 2023 12:28:20 +0000 (GMT)
Message-ID: <1a989ae0-f391-161c-6839-f3d0a617a173@samsung.com>
Date: Mon, 15 May 2023 14:28:19 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
	Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Content-Language: en-US
To: Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, jacob.e.keller@intel.com,
	saeedm@nvidia.com, moshe@nvidia.com
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <ZGIgIglwmOTX3IbS@shredder>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsWy7djP87opqkkpBnteWlnMOd/CYvH02CN2
	iyMnZjBZnDi2kMXi4tV0iwvb+lgtts/+x2JxbIGYxbfTbxgtvvXMZXPg8tiy8iaTx4JNpR67
	Ht5m91i85yWTx6ZVnWwevc3v2Dze77vK5nH1ZrXH501yAZxRXDYpqTmZZalF+nYJXBndXb8Y
	C05xVpz5ItfA+JC9i5GTQ0LAROLEhePMXYxcHEICKxglFp+9ywLhfGGU+N+/nx3C+cwocejx
	AzaYlp5vOxghEssZJdYs7GSFcD4ySmz/swpsMK+AncTauQdZQGwWAVWJufvWMUPEBSVOznwC
	FhcVSJVYtfkiWFxYIERi5tHfTCA2s4C4xK0n88FsEQFniVvt/5lAFjALrGaUuLXnGlgDm4Ch
	RNfbLrCTOAU0JNbs2MsK0Swvsf3tHLCPJATaOSU+T1oMdCsHkOMiMftoBMQLwhKvjm+BhoCM
	xOnJPSxQ9YwSC37fZ4JwJjBKNDy/xQhRZS1x59wvNpBBzAKaEut36UPMdJSYclINwuSTuPFW
	EOIEPolJ26YzQ4R5JTrahCBmqEnMOr4ObuvBC5eYJzAqzUIKlVlIvp+F5JlZCGsXMLKsYhRP
	LS3OTU8tNs5LLdcrTswtLs1L10vOz93ECExgp/8d/7qDccWrj3qHGJk4GA8xSnAwK4nwts+M
	TxHiTUmsrEotyo8vKs1JLT7EKM3BoiTOq217MllIID2xJDU7NbUgtQgmy8TBKdXAVNs766WW
	y0yuG3U7Ira7hs0Mvtq77mlTQOjRONPKV9avxT9Kti1Mfq1lXhy6tXxrcAjjE9XFaQxe6cvl
	PqxxnFt09uWk/M9Zrzcsrr8qe6LjluzqLOkZv7zOBymxb9p3Ib/o2gX3tvYlAf8vvb9h/F7u
	fGlH7jO1G4m89/odLtrdzl4+defCie+zv+ecfXpoXtFNjY+9zwOL+ZXsCneWvxc7zK26XuPT
	AoFPu+0D/1vsVTLKWXXppFbA95Myt5u5F0Sph1ec/8nPdZD51WXd63dfrps84+rPcxNMNj4Q
	1GNa6njbUcQ7XtfB7HJNzbXsldXT1H+b/4p+K6hXuyJGaVP+ql/LokKZFNfMvpH6MkWJpTgj
	0VCLuag4EQCYC4n7zwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/xe7opqkkpBo9eqFjMOd/CYvH02CN2
	iyMnZjBZnDi2kMXi4tV0iwvb+lgtts/+x2JxbIGYxbfTbxgtvvXMZXPg8tiy8iaTx4JNpR67
	Ht5m91i85yWTx6ZVnWwevc3v2Dze77vK5nH1ZrXH501yAZxRejZF+aUlqQoZ+cUltkrRhhZG
	eoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehndXb8YC05xVpz5ItfA+JC9i5GTQ0LA
	RKLn2w7GLkYuDiGBpYwS82beYIRIyEicnNbACmELS/y51sUGUfSeUeLyr8NsIAleATuJtXMP
	soDYLAKqEnP3rWOGiAtKnJz5BCwuKpAqcXLpDTBbWCBEYuvCWWBDmQXEJW49mc8EYosIOEvc
	av/PBBFfzShx7L8AxLLfjBI7360FO5VNwFCi620X2GJOAQ2JNTv2Qg0yk+ja2sUIYctLbH87
	h3kCo9AsJHfMQrJvFpKWWUhaFjCyrGIUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM2W3Hfm7e
	wTjv1Ue9Q4xMHIyHGCU4mJVEeNtnxqcI8aYkVlalFuXHF5XmpBYfYjQFBsZEZinR5Hxg0sgr
	iTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJzU5NLUgtgulj4uCUamCSDP13/98UATfmHVZ5
	Z/ZJl+W/nNeWqnbEdKVKc+bB7vn9oc8j6zc3blx00Nyhemr85CUC93ctWfZzbp5HfkNv+Hv+
	Ap85jDtXKrN/szOy4ltm+prjhvrNykeW/sKKP3h+uc2KLX74LF88e060p/1S20hbwwerTbqd
	9Ft9bjN38S2z6b5Sa8yfk9X7WrmLuzuqa9KZzSsWedquyNSUDcu4Pek6y08u5k8rDp+9eOlu
	wdb3Lle0vhsYtO87kb7y01P36yed9sXmC54q/CjR8PadzD177wsc5zwvlM1VOSgqvPDMhb6b
	r9v9ppp9MtSbyqNj/CSSuSUynmdiHRNPOKNW069Kz4w3uou/+3AKeCmxFGckGmoxFxUnAgD3
	35RLYgMAAA==
X-CMS-MailID: 20230515122820eucas1p1161474cf6453672c92ad076c85446a65
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7
References: <20230510144621.932017-1-jiri@resnulli.us>
	<CGME20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7@eucas1p2.samsung.com>
	<600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com>
	<ZGIY9jOHkHxbnTjq@nanopsycho> <ZGIgIglwmOTX3IbS@shredder>
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15.05.2023 14:05, Ido Schimmel wrote:
> On Mon, May 15, 2023 at 01:35:18PM +0200, Jiri Pirko wrote:
>> Thanks for the report. From the first sight, don't have a clue what may
>> be wrong. Debugging.
> I guess he has CONFIG_NET_NS disabled which turns "__net_initdata" to
> "__initdata" and frees the notifier block after init. "__net_initdata"
> is a NOP when CONFIG_NET_NS is enabled.
>
> Maybe this will help:
>
> diff --git a/net/devlink/core.c b/net/devlink/core.c
> index 0e58eee44bdb..c23ebabadc52 100644
> --- a/net/devlink/core.c
> +++ b/net/devlink/core.c
> @@ -294,7 +294,7 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
>          .pre_exit = devlink_pernet_pre_exit,
>   };
>   
> -static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
> +static struct notifier_block devlink_port_netdevice_nb = {
>          .notifier_call = devlink_port_netdevice_event,
>   };

Bingo, this fixes the issue.

Feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

to the final patch. Thanks!


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


