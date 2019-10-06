Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14357CD1FA
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfJFNFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:05:30 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36131 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfJFNF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:05:29 -0400
Received: by mail-ed1-f68.google.com with SMTP id h2so9960727edn.3
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 06:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lIqlYuP2E1obeyWlsnhCPku4Mg2mODs7Nt2z3I0bJgQ=;
        b=ekeWewP1Voy8XPTPFsdryhGPTcVo25VZmturAl/k42t+3oiN7yCxkz2GodbzmD98YW
         GAmb90+YV2JRj8oOitPy1pjFbPCnf4oCekj2K/fquun+D4xS0UAsWa5TRQvlHQaaL8C2
         0/ACE3+W7CB3Gdw4naZ57983zavYrRAK9OeV2GQGjgTvSaHH3ah7UCy0b2TMdtSd7VV7
         7+jfHQPbDuk5MgDHcpsrScoNwfsqQokDfe+/a+hx37ggtYIPdCkLYZ4oWAdWRtIgY2ov
         7fTBqjZzvmGtwCcMFgk4OMDH4N5q2GHPcXU6Pwg48/yLkudoFWnXEjvZCvCeOsMvpevr
         NZ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lIqlYuP2E1obeyWlsnhCPku4Mg2mODs7Nt2z3I0bJgQ=;
        b=oyI5KmXQzAvP0lqQf50V1WHV+iTKfykp0ajNcRsP/UFpqKl4cmUoege4mX4nhP9U5Y
         94crsxDInAIQWEf5g/fGMXV3ao6PItoRoZ8WzHwWtYR8Hbdoajuy8L7aGlYIJ4PN8mVW
         Q0GBFSQUdQZmnOYgtp/Sd2b/l17D8IXev2ugfHeL4yER6M1bgd9BKwsQNq60KyXmEFZ3
         gOVAMbbqRSpflQsFFjb0CQJVYNDRkDthz+o0JMUFNwtvSZ33LP+Hqs3elBbUUzEbGHWg
         ujgr1YZKuKL/33Zin0QPVn7I0jWblxwP4br08L8a3XpLXR+YDLfIy/4pLH4TeXCvGjuI
         B4PQ==
X-Gm-Message-State: APjAAAUo3qAiE+6EN+ypqBXaaREXXl1LMYvOI4ja6oy9hKI0Wq+f9lDC
        vA1nJYNtQR6ZaWO7G2POSyJGgE/U/ts=
X-Google-Smtp-Source: APXvYqxNDpQFQTLUZ3mdzA2fjVotmERokOBAqu8JtiOWgwoxWkjuNl4+SeJXv8wO+IjQ24DU5xGb6g==
X-Received: by 2002:a17:906:c72d:: with SMTP id fj13mr19848283ejb.36.1570367128017;
        Sun, 06 Oct 2019 06:05:28 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id e44sm2720471ede.34.2019.10.06.06.05.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 06 Oct 2019 06:05:27 -0700 (PDT)
Date:   Sun, 6 Oct 2019 15:05:26 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v5 net-next 3/7] ipeh: Generic TLV parser
Message-ID: <20191006130526.c65ibu5hoizctaq6@netronome.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-4-git-send-email-tom@herbertland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570139884-20183-4-git-send-email-tom@herbertland.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 02:58:00PM -0700, Tom Herbert wrote:
> From: Tom Herbert <tom@quantonium.net>
> 
> Create a generic TLV parser. This will be used with various
> extension headers that carry options including Destination,
> Hop-by-Hop, Segment Routing TLVs, and other cases of simple
> stateless parsing.
> 
> Signed-off-by: Tom Herbert <tom@herbertland.com>
> ---
>  include/net/ipeh.h        |  25 ++++++++
>  net/ipv6/exthdrs.c        | 159 +++++++++++-----------------------------------
>  net/ipv6/exthdrs_common.c | 114 +++++++++++++++++++++++++++++++++
>  3 files changed, 177 insertions(+), 121 deletions(-)
> 
> diff --git a/include/net/ipeh.h b/include/net/ipeh.h
> index 3b24831..c1aa7b6 100644
> --- a/include/net/ipeh.h
> +++ b/include/net/ipeh.h
> @@ -31,4 +31,29 @@ struct ipv6_txoptions *ipeh_renew_options(struct sock *sk,
>  struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
>  					  struct ipv6_txoptions *opt);
>  
> +/* Generic extension header TLV parser */
> +
> +enum ipeh_parse_errors {
> +	IPEH_PARSE_ERR_PAD1,		/* Excessive PAD1 */
> +	IPEH_PARSE_ERR_PADN,		/* Excessive PADN */
> +	IPEH_PARSE_ERR_PADNZ,		/* Non-zero padding data */
> +	IPEH_PARSE_ERR_EH_TOOBIG,	/* Length of EH exceeds limit */
> +	IPEH_PARSE_ERR_OPT_TOOBIG,	/* Option size exceeds limit */
> +	IPEH_PARSE_ERR_OPT_TOOMANY,	/* Option count exceeds limit */
> +	IPEH_PARSE_ERR_OPT_UNK_DISALW,	/* Unknown option disallowed */
> +	IPEH_PARSE_ERR_OPT_UNK,		/* Unknown option */
> +};
> +
> +/* The generic TLV parser assumes that the type value of PAD1 is 0, and PADN
> + * is 1. This is true for Destination, Hop-by-Hop and current definition
> + * of Segment Routing TLVs.
> + */
> +#define IPEH_TLV_PAD1	0
> +#define IPEH_TLV_PADN	1
> +
> +bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
> +		    int max_count, int off, int len,
> +		    bool (*parse_error)(struct sk_buff *skb,
> +					int off, enum ipeh_parse_errors error));
> +
>  #endif /* _NET_IPEH_H */

Hi Tom,

Unless I misread things, which is entirely possible, it seems
as well as moving code around this patch changes behaviour under
some error conditions via the parse_error callback and
the ipv6_parse_error() implementation of it below.

I think such a change is worth of at lest calling out in the changelog
and perhaps braking out into a separate patch.

...
