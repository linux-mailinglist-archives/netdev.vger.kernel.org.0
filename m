Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62D4370347
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhD3V4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:56:17 -0400
Received: from p3plsmtpa07-06.prod.phx3.secureserver.net ([173.201.192.235]:53662
        "EHLO p3plsmtpa07-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhD3V4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 17:56:13 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id cb6Zl3LAWLUlzcb6ZlWr3l; Fri, 30 Apr 2021 14:55:24 -0700
X-CMAE-Analysis: v=2.4 cv=Bewdbph2 c=1 sm=1 tr=0 ts=608c7ccc
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=eUCHAjWJAAAA:8
 a=MYg0ok330wZcJcPOri0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=e1s5y4BJLze_2YVawdyF:22
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <netdev@vger.kernel.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com> <1619162596-23846-5-git-send-email-moshe@nvidia.com>
In-Reply-To: <1619162596-23846-5-git-send-email-moshe@nvidia.com>
Subject: RE: [PATCH ethtool-next 4/4] ethtool: Update manpages for getmodule (-m) command
Date:   Fri, 30 Apr 2021 14:55:23 -0700
Message-ID: <008701d73e0b$85a7d490$90f77db0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIoIhiQoNl9y+8EvClCms9DfxFPhwEmLYfGqiKfCwA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfLKMO3RwvsXs4b2VpoFGCuheCldGLky/vo7LBCJBwe6diKVl+NxV0LGnEXA83NnjVHItHuuoa4ZlL/Kq1kk5tFVSex5UoMDaREGh+iTmIMTmoh0TVciZ
 VCt5CbBh4z2N/3gnafQIoeYM/6xKc9xIbob9//Ym0GMQh+uzvVrf4r0N8k2wHMSBIZFljBNhPbiun5ay3trqRqCY1UqAXpVbCrVhEUSraiM8VRVzGw4FOb7y
 0qdqDhTQVs0zQ5Z051FEsxje7Gqx/+qvMaSUFXydWOQ6T9OSg6VUBdu4Jwxt6wWF29O97XZ97ED6P9EqZKCIL+3OrdIHLBmN0oVSoMU0FJo=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Moshe Shemesh [mailto:moshe@nvidia.com]
> Sent: Friday, April 23, 2021 12:23 AM
> To: Michal Kubecek <mkubecek@suse.cz>; Andrew Lunn
> <andrew@lunn.ch>; Jakub Kicinski <kuba@kernel.org>; Don Bollinger
> <don@thebollingers.org>; netdev@vger.kernel.org
> Cc: Vladyslav Tarasiuk <vladyslavt@nvidia.com>; Moshe Shemesh
> <moshe@nvidia.com>
> Subject: [PATCH ethtool-next 4/4] ethtool: Update manpages for getmodule
> (-m) command
> 
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> Add page, bank and i2c parameters and mention change in offset and length
> treatment if either one of new parameters is specified by the user.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> ---
>  ethtool.8.in | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/ethtool.8.in b/ethtool.8.in index fe49b66..9516458 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -359,6 +359,9 @@ ethtool \- query or control network driver and
> hardware settings
>  .B2 hex on off
>  .BN offset
>  .BN length
> +.BN page
> +.BN bank
> +.BN i2c
>  .HP
>  .B ethtool \-\-show\-priv\-flags
>  .I devname
> @@ -1154,6 +1157,17 @@ Changes the number of multi-purpose channels.
>  Retrieves and if possible decodes the EEPROM from plugin modules, e.g
> SFP+, QSFP.
>  If the driver and module support it, the optical diagnostic information
is also
> read and decoded.
> +When either one of
> +.I page,
> +.I bank
> +or
> +.I i2c
> +parameters is specified, dumps only of a single page or its portion is
> +allowed. In such a case .I offset and .I length parameters are treated
> +relatively to EEPROM page boundaries.

You want 'relative', not 'relatively'.

Please spend a few more words on this.  Basically there are two choices.
Assuming lower memory cannot be accessed when page 2 is specified, the
offset of the first byte of page 2 is either 0 or 128.  I can't tell which
of those choices you mean.

Also, based on the code in the other patches, I assume you mean that the
first byte of page 2 is at offset 0.  I recommend against that.  The specs
all assume that the first byte ***of the paged area*** of page 2 (or any
other page) is at 128.  Hundreds of registers are specified in each spec,
all with offsets in the range 128-255.  The ONLY purpose of this option to
ethtool is to manage those registers, per those specs.  Forcing every user
to translate between the spec and the tool is going to be tedious and error
prone.



>  .TP
>  .B \-\-show\-priv\-flags
>  Queries the specified network device for its private flags.  The
> --
> 2.26.2

Don


