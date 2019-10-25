Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C9CE420B
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404059AbfJYDWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:22:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38642 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731941AbfJYDWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:22:01 -0400
Received: by mail-qt1-f194.google.com with SMTP id o25so1213257qtr.5;
        Thu, 24 Oct 2019 20:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s3InfjO9Pb2WNJ6n4eiBhTWH+wqZSiTt+aWjUBe2lpw=;
        b=BY6w9qR9LbNXPMJgd4P2NPJgNrLgfBoAsL7ZxJyjHLtvFf0LzFl7zLDQ+/wNyTemYW
         LuAlqlpLpOKORJr2MB358ZYBKXYKNzcJeUFEEEcmkn4t2nT/+HyQ6uPMuTZT4w+akxKB
         Cne6MuEh9iBME0FPPs/G2e2zhF8/2NPKBQD78TNFTkpSE2wzw9ZB+eH1U1ToSyImdeul
         YALbGceIVO231Mxdxn+G2AZbX6103XKzq7kOlPpopSqNPqVmdLMHFinA/V1VzBwXFMVJ
         p8v2/HHQOcB5DALJ/CXKQ8rgU8Xh/CDpiKlo7TfYWg00VJcl6IrBc49U1x/gGR3YfaVb
         Io/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s3InfjO9Pb2WNJ6n4eiBhTWH+wqZSiTt+aWjUBe2lpw=;
        b=M9FwhNjUQIWr6Sb+RwhPfofG2minA3wBIh/ivNeF1YANPypuv/th1ItXXshYtoj3JH
         vpgs7/0NLx5WGBgj7H8Hl4sT/K4zSi6gKyXttfR2NkwoF/Z82h3Teap57BkqfVXg9uiN
         lM5AA/dAoADwKcv2hsJjJtyoX2fzT4VNdT1zq8bF0k79LS3GszIRk0yoXdUE2a3zuW9o
         wLJ/Dj2HEJDXYpJ4KagA8ySY5gvEHR407oEUWHRbUnRrJmZVG46NEQDpneAX4XoHYVJU
         7eZ7SwygXmw+uQUY610Js4cU8c9TAZo4r2X4PfAPZJGk33SC6rcfMkqiZ3RoyRMSjoci
         GR1Q==
X-Gm-Message-State: APjAAAV4qGQlkc4AeCXT9a6TxsmlTF9ZYT9wqEZ86V11htGIj42F2biL
        9YPIByaPTKq16odCguq5sN8=
X-Google-Smtp-Source: APXvYqwkJmpEtXDUhjJL4x18jGyacmx0x7aPMnl2U/prxsMi3+qSnAL04XlogDZSJWTmRYgpvyotmw==
X-Received: by 2002:a0c:ea34:: with SMTP id t20mr1199158qvp.242.1571973720270;
        Thu, 24 Oct 2019 20:22:00 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.193])
        by smtp.gmail.com with ESMTPSA id p56sm452054qtp.81.2019.10.24.20.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 20:21:59 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 96995C0AD9; Fri, 25 Oct 2019 00:21:56 -0300 (-03)
Date:   Fri, 25 Oct 2019 00:21:56 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: Re: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED
 notification
Message-ID: <20191025032156.GA4326@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry for the long delay on this review.

On Mon, Oct 14, 2019 at 02:14:44PM +0800, Xin Long wrote:
> SCTP Quick failover draft section 5.1, point 5 has been removed
> from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
> Layer Protocol (ULP) about this state transition", as said in
> section 3.2, point 8.
> 
> So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
> in section 7.1, "which is reported if the affected address
> becomes PF". Also remove transport cwnd's update when moving
> from PF back to ACTIVE , which is no longer in rfc7829 either.
> 
> v1->v2:
>   - no change
> v2->v3:
>   - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/uapi/linux/sctp.h |  2 ++
>  net/sctp/associola.c      | 17 ++++-------------
>  2 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index 6bce7f9..f4ab7bb 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -410,6 +410,8 @@ enum sctp_spc_state {
>  	SCTP_ADDR_ADDED,
>  	SCTP_ADDR_MADE_PRIM,
>  	SCTP_ADDR_CONFIRMED,
> +	SCTP_ADDR_POTENTIALLY_FAILED,
> +#define SCTP_ADDR_PF	SCTP_ADDR_POTENTIALLY_FAILED
>  };
>  
>  
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 1ba893b..4f9efba 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,

While at here, dealing with spc_state, please seize the moment and
initialize it to the enum instead:

@@ -787,7 +787,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
                                  sctp_sn_error_t error)
 {
        bool ulp_notify = true;
-       int spc_state = 0;
+       int spc_state = SCTP_ADDR_AVAILABLE;


>  			spc_state = SCTP_ADDR_CONFIRMED;
>  		else
>  			spc_state = SCTP_ADDR_AVAILABLE;

This else could be removed (equals to initial value).

> -		/* Don't inform ULP about transition from PF to
> -		 * active state and set cwnd to 1 MTU, see SCTP
> -		 * Quick failover draft section 5.1, point 5
> -		 */
> -		if (transport->state == SCTP_PF) {
> -			ulp_notify = false;
> -			transport->cwnd = asoc->pathmtu;
> -		}
>  		transport->state = SCTP_ACTIVE;
>  		break;
>  
> @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
>  		 * to inactive state.  Also, release the cached route since
>  		 * there may be a better route next time.
>  		 */
> -		if (transport->state != SCTP_UNCONFIRMED)
> +		if (transport->state != SCTP_UNCONFIRMED) {
>  			transport->state = SCTP_INACTIVE;
> -		else {
> +			spc_state = SCTP_ADDR_UNREACHABLE;
> +		} else {
>  			sctp_transport_dst_release(transport);
>  			ulp_notify = false;
>  		}
> -
> -		spc_state = SCTP_ADDR_UNREACHABLE;
>  		break;
>  
>  	case SCTP_TRANSPORT_PF:
>  		transport->state = SCTP_PF;
> -		ulp_notify = false;
> +		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
>  		break;
>  
>  	default:
> -- 
> 2.1.0
> 
