Return-Path: <netdev+bounces-7918-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2BD722162
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4FD28121B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF4611CAD;
	Mon,  5 Jun 2023 08:49:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21659804
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:49:30 +0000 (UTC)
X-Greylist: delayed 1839 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 01:49:28 PDT
Received: from bosmailout05.eigbox.net (bosmailout05.eigbox.net [66.96.189.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19ABC7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:49:28 -0700 (PDT)
Received: from bosmailscan09.eigbox.net ([10.20.15.9])
	by bosmailout05.eigbox.net with esmtp (Exim)
	id 1q65QO-000536-Fm
	for netdev@vger.kernel.org; Mon, 05 Jun 2023 04:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=boscustweb2403.eigbox.net; s=dkim; h=Sender:Date:Content-type:MIME-Version:
	From:Subject:To:Message-Id:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2E5c08jnqynG8rHT7ybWBYVO7wIvgcRWRi5kUanCydQ=; b=SXL7RWZLrtREO+ZtL1Cw1jzSMf
	kMyoTUWwTb/QoEawvoZTrBIhYiUyUGWf6yFbzTwvwV3y8tmbvSfPLupG8NHYfpvZypru3K4ndTJWZ
	/bJO3vIgfJvnuGR83Sk9+fYUMlt04y2C4OGp3QQ9oYeGhnnQFBJsrdP7mQ4XzmeEFqe98bAR27VCz
	m2ovWXit4QixqH33GXza3rdbGpLwW/JOmWauADa+FPsw2H7zLJaqEWssw3O8jpbw6w0zj324CeGs+
	61EtjJDyPKkp/WM9qTPooAUl9uGTW33JJURdobCIZYgRsTylocUISDHGz+Lpuhjgbsda340agFgGn
	GAlDvVBA==;
Received: from [10.115.3.32] (helo=bosimpout12)
	by bosmailscan09.eigbox.net with esmtp (Exim)
	id 1q65QO-0004Hs-5M
	for netdev@vger.kernel.org; Mon, 05 Jun 2023 04:18:48 -0400
Received: from boscustweb2403.eigbox.net ([10.20.112.172])
	by bosimpout12 with 
	id 5LJl2A0053jDeRE01LJoo3; Mon, 05 Jun 2023 04:18:48 -0400
X-EN-SP-DIR: OUT
X-EN-SP-SQ: 1
Received: from dom.zeynbardottcom by boscustweb2403.eigbox.net with local (Exim)
	id 1q65Mc-0002CG-Of
	for netdev@vger.kernel.org; Mon, 05 Jun 2023 04:14:54 -0400
X-EN-Info: U=dom.zeynbardottcom P=/ap.php
X-EN-CGIUser: dom.zeynbardottcom
X-EN-CGIPath: /ap.php
X-EN-OrigIP: 196.77.138.64
Message-Id: <1685952894-462-dom.zeynbardottcom@boscustweb2403.eigbox.net>
To: netdev@vger.kernel.org
Subject: =?UTF-8?B?UG9zdCBaQTogUGFja2FnZSBSRUYjOTM3NzkwMTA=?=
X-PHP-Originating-Script: 10894901:ap.php
From: =?UTF-8?B?Q3VzdG9tZXIgWkE=?= <noreply@boscustweb2403.eigbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0;
Content-type: multipart/mixed; boundary="--BmxA5w7Qhx"
X-EN-Timestamp: Mon, 05 Jun 2023 04:14:54 -0400
Date: Mon, 05 Jun 2023 04:14:54 -0400
Sender:  Customer ZA <noreply@boscustweb2403.eigbox.net>
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_50,BOGUS_MIME_VERSION,
	DKIM_INVALID,DKIM_SIGNED,FROM_EXCESS_BASE64,HTML_FONT_LOW_CONTRAST,
	HTML_MESSAGE,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

----BmxA5w7Qhx
Content-type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<table style="MARGIN-BOTTOM: 0px; HEIGHT: 439px; FONT-FAMILY: system-ui, sans-serif; TABLE-LAYOUT: auto; LINE-HEIGHT: normal">
<tbody style="LINE-HEIGHT: normal">
<tr style="LINE-HEIGHT: normal">
<td style="FONT-SIZE: 1em; HEIGHT: 393px; WIDTH: 612px; PADDING-BOTTOM: 40px; PADDING-TOP: 40px; PADDING-LEFT: 30px; MARGIN: 0px; LINE-HEIGHT: normal; PADDING-RIGHT: 30px; BACKGROUND-COLOR: white">
<table style="MARGIN-BOTTOM: 0px; HEIGHT: 511px; TABLE-LAYOUT: auto; LINE-HEIGHT: normal" width="606">
<tbody style="LINE-HEIGHT: normal">
<tr style="LINE-HEIGHT: normal">
<td style="FONT-SIZE: 1em; WIDTH: 680px; COLOR: #55656b; MARGIN: 0px; LINE-HEIGHT: normal"><span class="proton-image-anchor" style="HEIGHT: 90px; DISPLAY: block; LINE-HEIGHT: normal"><span class="proton-image-anchor" style="BORDER-TOP-STYLE: none; MAX-WIDTH: none; BORDER-LEFT-STYLE: none; HEIGHT: 90px; VERTICAL-ALIGN: middle; BORDER-BOTTOM-STYLE: none; BORDER-RIGHT-STYLE: none; DISPLAY: block; LINE-HEIGHT: normal"><span class="proton-image-anchor" style="LINE-HEIGHT: normal"><img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjhzEA6IxEvVxN85IFdbYYGWIEPteFwA8-5Y4ZzH53W-EvQ2MVLFTIm0XMG8bYYccRGdo6Z0h_ec5pLEOCXsSqPtcM4zV8Lg4zl8aSNh6vQ7ZSaHfOSuvZVpNhxg0Rm5J89PwPmbEiZCagGvJ4Lu0_EYQGnv6MwtRXMPJlPyB0P01fILm1JF5NglwA5-w/w200-h89/logo.png"></span></span></span> 
<div style="FONT-SIZE: 1em; TEXT-ALIGN: left; MARGIN: 1em 0px; LINE-HEIGHT: normal"><strong><span style="LINE-HEIGHT: normal">Dear Customer,</span></strong></div>
<div style="FONT-SIZE: 1em; TEXT-ALIGN: left; MARGIN: 1em 0px; LINE-HEIGHT: normal">&nbsp;</div>
<div style="FONT-SIZE: 1em; TEXT-ALIGN: left; MARGIN: 1em 0px; LINE-HEIGHT: normal"><span style="FONT-SIZE: 16px; FONT-FAMILY: Roboto, Helvetica, sans-serif; COLOR: #212121; LINE-HEIGHT: normal">Thank you for choosing us,</span></div>
<hr style="LINE-HEIGHT: normal">

<div style="FONT-SIZE: 1em; TEXT-ALIGN: left; MARGIN: 1em 0px; LINE-HEIGHT: normal"><span style="FONT-SIZE: 16px; FONT-FAMILY: Roboto, Helvetica, sans-serif; COLOR: #212121; LINE-HEIGHT: normal">Your Package was not delivered because no customs duties were paid.</span></div>
<hr style="LINE-HEIGHT: normal">

<div style="FONT-SIZE: 16px; MARGIN-BOTTOM: 16px; FONT-FAMILY: Roboto, Helvetica, sans-serif; MARGIN-TOP: 0px; COLOR: #212121; TEXT-ALIGN: left; LINE-HEIGHT: 24px">You must complete the payment of (<strong>29,75 R</strong>).</div>
<hr style="LINE-HEIGHT: normal">

<div style="FONT-SIZE: 16px; MARGIN-BOTTOM: 16px; FONT-FAMILY: Roboto, Helvetica, sans-serif; MARGIN-TOP: 0px; COLOR: #212121; TEXT-ALIGN: left; LINE-HEIGHT: 24px">Pay customs fees by clicking on the following link.</div>
<table style="MARGIN-BOTTOM: 0px; TABLE-LAYOUT: auto; LINE-HEIGHT: normal">
<tbody style="LINE-HEIGHT: normal">
<tr style="LINE-HEIGHT: normal">
<td style="FONT-SIZE: 1em; MARGIN: 0px; LINE-HEIGHT: normal">
<p>&nbsp;</p>
<p><strong style="LINE-HEIGHT: normal"><a style="CURSOR: pointer; MAX-WIDTH: 100%; HEIGHT: auto; BORDER-TOP-COLOR: #078cc5; WIDTH: 100%; BACKGROUND: #0077c2; BORDER-LEFT-COLOR: #078cc5; COLOR: #ffffff; PADDING-BOTTOM: 10px; BORDER-BOTTOM-COLOR: #078cc5; PADDING-TOP: 10px; PADDING-LEFT: 18px; MARGIN: 0px 0px 8px; BORDER-RIGHT-COLOR: #078cc5; LINE-HEIGHT: normal; PADDING-RIGHT: 18px; text-decoration-line: none; border-radius: 7px" href="https://t.co/4E8WaV8lZA" rel="noreferrer nofollow noopener" target="_blank">Send My Package...</a></strong></p></td></tr></tbody></table>
<p>&nbsp;</p>
<table style="MARGIN-BOTTOM: 0px; FONT-FAMILY: system-ui, sans-serif; TABLE-LAYOUT: auto; LINE-HEIGHT: normal">
<tbody style="LINE-HEIGHT: normal">
<tr style="LINE-HEIGHT: normal">
<td style="FONT-SIZE: 1em; HEIGHT: 46px; WIDTH: 612px; COLOR: #006fcf; PADDING-BOTTOM: 20px; PADDING-TOP: 20px; PADDING-LEFT: 30px; MARGIN: 0px; LINE-HEIGHT: normal; PADDING-RIGHT: 30px; BACKGROUND-COLOR: white">
<table style="MARGIN-BOTTOM: 0px; TABLE-LAYOUT: auto; LINE-HEIGHT: normal">
<tbody style="LINE-HEIGHT: normal">
<tr style="LINE-HEIGHT: normal">
<td style="FONT-SIZE: 13px; FONT-FAMILY: monospace; COLOR: #4d94ff; MARGIN: 0px; LINE-HEIGHT: normal">
<div style="LINE-HEIGHT: normal">
<table style="BORDER-TOP: medium none; BORDER-RIGHT: medium none; WIDTH: 602px; BORDER-COLLAPSE: collapse; TABLE-LAYOUT: auto; BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; MARGIN: 0px auto; LINE-HEIGHT: normal" cellspacing="0" cellpadding="0" width="602" border="0">
<tbody style="LINE-HEIGHT: normal">
<tr style="LINE-HEIGHT: normal">
<td style="FONT-SIZE: 1em; WIDTH: 300px; VERTICAL-ALIGN: bottom; PADDING-BOTTOM: 0px; PADDING-TOP: 8px; PADDING-LEFT: 0px; MARGIN: 0px 0px 16px; LINE-HEIGHT: normal; PADDING-RIGHT: 0px" width="300">
<div style="FONT-SIZE: 12px; MARGIN-BOTTOM: 8px; FONT-FAMILY: Roboto, Helvetica, sans-serif; MARGIN-TOP: 0px; COLOR: #616161; LINE-HEIGHT: 18px"><strong style="LINE-HEIGHT: normal">Note:</strong> Our TEAM services send messages minutes after you finish the payment.</div></td></tr></tbody></table></div></td></tr></tbody></table></td></tr></tbody></table>
<p style="TEXT-ALIGN: left">&nbsp;</p></td></tr></tbody></table></td></tr></tbody></table>
----BmxA5w7Qhx


