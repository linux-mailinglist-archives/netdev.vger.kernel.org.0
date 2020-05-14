Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61991D32A2
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgENOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:22:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35914 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbgENOWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:22:15 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7A3382011E;
        Thu, 14 May 2020 14:22:14 +0000 (UTC)
Received: from us4-mdac16-35.at1.mdlocal (unknown [10.110.49.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 78F67800AD;
        Thu, 14 May 2020 14:22:14 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4DAB100078;
        Thu, 14 May 2020 14:22:13 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A501280069;
        Thu, 14 May 2020 14:22:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 14 May
 2020 15:22:07 +0100
Subject: Re: [PATCH iproute2/net-next] man: tc-ct.8: Add manual page for ct tc
 action
To:     Paul Blakey <paulb@mellanox.com>, <netdev@vger.kernel.org>,
        <dsahern@gmail.com>, <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
CC:     <ozsh@mellanox.com>, <roid@mellanox.com>
References: <1589465420-12119-1-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b7e57c78-3bf5-bf48-0a15-d862e2697df0@solarflare.com>
Date:   Thu, 14 May 2020 15:22:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1589465420-12119-1-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25418.003
X-TM-AS-Result: No-8.855800-8.000000-10
X-TMASE-MatchedRID: y/2oPz6gbvjmLzc6AOD8DfHkpkyUphL9sKzLQnnS/xwGmHr1eMxt2YB5
        w6KBECW1mIBItNUDT+32l8Yqntp5eVuDsARvj1N5/NOUkr6ADzdbD9LQcHt6gwdkFovAReUoilv
        Ab18i4hMtp61/ZdkjWAfSny2qD3NvGyUVzbYEuf8Sq+XFWzaAyrfHCp+e+coeRjNrjV0arFI+s3
        kix3GatSIsgbNx3Khf3g+O46VEzGVmVB9VY/IHEwm6mWzI013HV0QSZ/pNFUG/VzeWm7Nd2NjUX
        NGf8VVtBX3les/5H/rgfUR1p/fGQZH0YXYnbGozOX/V8P8ail1ZDL1gLmoa/PoA9r2LThYYKrau
        Xd3MZDWZlG1M4jOggCXGLacbUNaFtVUQPB9QiwoWlTnXl3OFhBZGBMzOyk3iFluMpgcbjJQYp1D
        CSlQ7LSqrgOYsDdlj09c1tAYnD4srzxvBh2nlswbEQIfFpkwHBtlgFh29qnpKzBwu5JpklnOUuo
        TXM7r4QwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.855800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25418.003
X-MDID: 1589466134-h9HjEMnpED6M
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/05/2020 15:10, Paul Blakey wrote:
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> ---
>  man/man8/tc-ct.8     | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/tc-flower.8 |   6 +++
>  2 files changed, 113 insertions(+)
>  create mode 100644 man/man8/tc-ct.8
Glad to see this, better tc documentation generally is sorely needed.
See comments inline below.

> diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
> new file mode 100644
> index 0000000..45d2932
> --- /dev/null
> +++ b/man/man8/tc-ct.8
> @@ -0,0 +1,107 @@
> +.TH "ct action in tc" 8 "14 May 2020" "iproute2" "Linux"
> +.SH NAME
> +ct \- tc connection tracking action
> +.SH SYNOPSIS
> +.in +8
> +.ti -8
> +.BR "tc ... action ct commit [ force ] [ zone "
> +.IR ZONE
> +.BR "] [ mark "
> +.IR MASKED_MARK
> +.BR "] [ label "
> +.IR MASKED_LABEL
> +.BR "] [ nat "
> +.IR NAT_SPEC
> +.BR "]"
> +
> +.ti -8
> +.BR "tc ... action ct [ nat ] [ zone "
> +.IR ZONE
> +.BR "]"
> +
> +.ti -8
> +.BR "tc ... action ct clear"
> +
> +.SH DESCRIPTION
> +The ct action is a tc action for sending packets and interacting with the netfilter conntrack module.
> +
> +It can (as shown in the synopsis, in order):
> +
> +Send the packet to conntrack, and commit the connection, while configuring
> +a 32bit mark, 128bit label, and src/dst nat.
> +
> +Send the packet to conntrack, which will mark the packet with the connection's state and
> +configured metadata (mark/label), and execute previous configured nat.
"... and optionally execute..." perhaps?
Since it'll only do this if the 'nat' option was passed.

> +
> +Clear the packet's of previous connection tracking state.
> +
> +.SH OPTIONS
> +.TP
> +.BI zone " ZONE"
> +Specify a conntrack zone number on which to send the packet to conntrack.
> +.TP
> +.BI mark " MASKED_MARK"
> +Specify a masked 32bit mark to set for the connection (only valid with commit).
> +.TP
> +.BI label " MASKED_LABEL"
> +Specify a masked 128bit label to set for the connection (only valid with commit).
> +.TP
> +.BI nat " NAT_SPEC"
> +.BI Where " NAT_SPEC " ":= {src|dst} addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]"
> +
> +Specify src/dst and range of nat to configure for the connection (only valid with commit).
> +.RS
> +.TP
> +src/dst - configure src or dst nat
> +.TP
> +.BI  "" "addr1" "/" "addr2" " - IPv4/IPv6 addresses"
> +.TP
> +.BI  "" "port1" "/" "port2" " - Port numbers"
> +.RE
> +.TP
> +.BI nat
> +Restore any previous configured nat.
> +.TP
> +.BI clear
> +Remove any conntrack state and metadata (mark/label) from the packet (must only option 
"... must be only option...".

- Ed
