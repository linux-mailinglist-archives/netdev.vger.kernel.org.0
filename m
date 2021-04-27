Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B958736BE0D
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 05:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhD0Dza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 23:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhD0Dz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 23:55:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB25C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 20:54:38 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y1so14466241plg.11
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 20:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jypizziJjXEKYrQtWFJ+QnY3xCLO0t7gHdhzrV2LXEM=;
        b=cAPPbuabLPwsspAHhDP2KB8vdl3chXCWeTJ6E92hgyXUq3jWVGF6Axw4zF1MdEZzls
         I/Lcpe16fQjADyzWTGl+FtjuCM52Yb7jjgtYPoe5MYzZcjzdhz0SIADk56dM3OpJPtu0
         7gVLGlListpCa/sIRC0WF6aNOeS0V8OatW8nGLZB2mSm3v0VpT5x2B4BpV6g6hqhxjrr
         vNOq/POX6cWMWJdGPn9aNZ7GNfDVvCG0gXKokFi+bdaD2w/qhdk1B2C7NwX5DmwjM0GT
         GOAagIaXmVnf3JtX1OM0TruWOzu/a5r+UdFZo48AU1SeinaWgMot8E3WLLIJOI4k0BZU
         MUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jypizziJjXEKYrQtWFJ+QnY3xCLO0t7gHdhzrV2LXEM=;
        b=lqxbAxuvVWF7EJ6InZoE8hmxxbRL4xss8JpQ1jH5Y01Uon0NqezLW1S37fADv05VBH
         YHHLVtLUz0QDXlHhIV5snCkCyIWO/RvvOmgCd4OadsepeawiCW3/sUnduiW05v53T1Yd
         SjxAMU+FUOJE0HFanCMt/MGkVGSyVA4nWjPaNHN6G6xCONCYFXlNlLzUmLBdCoL0nHFA
         uywvyVCgDxnA3762gyjm/KY8xz4yv4VmSkRcw0dCZEO7I+UlnHJTkvKRTWHQvNqKwDwG
         3abwxAXpi3cch/E9V9QsSOm/VXCD2cpzYfNmfkbkJqweyrG5sdr8CkDc+CvM6/xWo35J
         BrpA==
X-Gm-Message-State: AOAM531kpxUgEl7b0xxQUIDIBw7NZGeEXAlcbazxfL2ccHMl4JIUZkXK
        4OtJKVq9jyKASkbGtMZEImeSUA==
X-Google-Smtp-Source: ABdhPJwM275mWdYqXihw6YxqWNbqsIX4c7CRUb1I41pEciPfSeohdaYeMkwh0c7uEkf1IlltTUQ0gQ==
X-Received: by 2002:a17:902:7444:b029:ed:5334:40b6 with SMTP id e4-20020a1709027444b02900ed533440b6mr2778010plt.35.1619495677565;
        Mon, 26 Apr 2021 20:54:37 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id a6sm1001486pfh.135.2021.04.26.20.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 20:54:37 -0700 (PDT)
Date:   Mon, 26 Apr 2021 20:54:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] icmp: standardize naming of RFC 8335 PROBE
 constants
Message-ID: <20210426205434.248bed86@hermes.local>
In-Reply-To: <20210427034002.291543-1-andreas.a.roeseler@gmail.com>
References: <20210427034002.291543-1-andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Apr 2021 22:40:02 -0500
Andreas Roeseler <andreas.a.roeseler@gmail.com> wrote:

> The current definitions of constants for PROBE are inconsistent, with
> some beginning with ICMP and others with simply EXT. This patch
> attempts to standardize the naming conventions of the constants for
> PROBE, and update the relevant definitions in net/ipv4/icmp.c.
> 
> Similarly, the definitions for the code field (previously
> ICMP_EXT_MAL_QUERY, etc) use the same prefixes as the type field. This
> patch adds _CODE_ to the prefix to clarify the distinction of these
> constants.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  include/uapi/linux/icmp.h | 28 ++++++++++++++--------------
>  net/ipv4/icmp.c           | 16 ++++++++--------
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> index 222325d1d80e..c1da8244c5e1 100644
> --- a/include/uapi/linux/icmp.h
> +++ b/include/uapi/linux/icmp.h
> @@ -70,22 +70,22 @@
>  #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
>  
>  /* Codes for EXT_ECHO (PROBE) */
> -#define ICMP_EXT_ECHO		42
> -#define ICMP_EXT_ECHOREPLY	43
> -#define ICMP_EXT_MAL_QUERY	1	/* Malformed Query */
> -#define ICMP_EXT_NO_IF		2	/* No such Interface */
> -#define ICMP_EXT_NO_TABLE_ENT	3	/* No such Table Entry */
> -#define ICMP_EXT_MULT_IFS	4	/* Multiple Interfaces Satisfy Query */
> +#define ICMP_EXT_ECHO			42
> +#define ICMP_EXT_ECHOREPLY		43
> +#define ICMP_EXT_CODE_MAL_QUERY		1	/* Malformed Query */
> +#define ICMP_EXT_CODE_NO_IF		2	/* No such Interface */
> +#define ICMP_EXT_CODE_NO_TABLE_ENT	3	/* No such Table Entry */
> +#define ICMP_EXT_CODE_MULT_IFS		4	/* Multiple Interfaces Satisfy Query */
>  
>  /* Constants for EXT_ECHO (PROBE) */
> -#define EXT_ECHOREPLY_ACTIVE	(1 << 2)/* active bit in reply message */
> -#define EXT_ECHOREPLY_IPV4	(1 << 1)/* ipv4 bit in reply message */
> -#define EXT_ECHOREPLY_IPV6	1	/* ipv6 bit in reply message */
> -#define EXT_ECHO_CTYPE_NAME	1
> -#define EXT_ECHO_CTYPE_INDEX	2
> -#define EXT_ECHO_CTYPE_ADDR	3
> -#define ICMP_AFI_IP		1	/* Address Family Identifier for ipv4 */
> -#define ICMP_AFI_IP6		2	/* Address Family Identifier for ipv6 */
> +#define ICMP_EXT_ECHOREPLY_ACTIVE	(1 << 2)/* active bit in reply message */
> +#define ICMP_EXT_ECHOREPLY_IPV4		(1 << 1)/* ipv4 bit in reply message */
> +#define ICMP_EXT_ECHOREPLY_IPV6		1	/* ipv6 bit in reply message */
> +#define ICMP_EXT_ECHO_CTYPE_NAME	1
> +#define ICMP_EXT_ECHO_CTYPE_INDEX	2
> +#define ICMP_EXT_ECHO_CTYPE_ADDR	3
> +#define ICMP_AFI_IP			1	/* Address Family Identifier for ipv4 */
> +#define ICMP_AFI_IP6			2	/* Address Family Identifier for ipv6 */

You can't just remove the old constants. They have to stay there.
The #defines are part of the Linux API by now.
