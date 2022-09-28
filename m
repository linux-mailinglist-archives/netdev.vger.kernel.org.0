Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6115ED5A5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiI1HDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiI1HDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:03:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97901AB07E
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:03:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r18so25116662eja.11
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=GngrfVpZrcJOM4lLIL3Gfo4H+pjNufT+D+M2F0/U9As=;
        b=jypAlMRAPRQpR7Xc9Zzvo+r3WmhmFw+/x5sKqwnfgUJgV0s7G1viRSPOhfhn4G5bfr
         o6XIlN0vwJzcqjDYgrbImui08zQtYyZIHAqv84kLPmcVLYpn7NSqSeseneHQfrL4zG8z
         CbdmMLjcvpVjwTkFEUs62wquL2EYGpRyv1tWEHSnE7L6pIpJzK0ie+6PQe/V+6D9n3P6
         us5Zq9lUZAvJ+zzpUa5RTS6NF2bKaUBNxpi7NG1pF9+Lov/CZbCV/bbETo7+SC+BMzCN
         3RbDNXMA+Ltujo1xuekxfaEIRfQy7RHLL2p3XAEjad2JETRleS9viCO+JH8PpsPJDunU
         6Yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=GngrfVpZrcJOM4lLIL3Gfo4H+pjNufT+D+M2F0/U9As=;
        b=dOOhs5vqBkkXn1ytYY5xaZ6kN3F3yrdv3hyFS9EXlrNeJbDsZimfao+P3v/DvRxcy/
         r8Q9kXBtOwlK3lwx8stXoCnEWDJnpFBFkYCga93xb5dRVHkNxBMyGZX6rHlnI7krcqua
         ybR8UVBA1jzgQPQ5vUvVs5aTuFC8DANK3gFWneZPdEQ+gfVnh0DoOEP+GrzGF1dQpY34
         wGAKm1CQRmVRZuB8tdwsHlqYM3iLT+3Q/wCb7od66J4KgkQtBofas9iP24xHY3Lp63ob
         yjdfphu5ORNT0TJDJVxRNJBG0ohpBMOZuszIKcW0GmK4X+GcYOMIPFwVrdREqqaVYhTu
         5TCg==
X-Gm-Message-State: ACrzQf0A+3aSftveLfGav1W85Zzs4tAwv1sZszp9qixVFnfM2iuy8nch
        6Vctgci+qypa6A6Zg7MDF7gxOQ==
X-Google-Smtp-Source: AMsMyM4RlK+e1T+q0W/kbnQYrmM6cr5xTwEczFdDNVzyimq6K64ZY0oN0y4mkNWPgALV94clQXWu5w==
X-Received: by 2002:a17:906:8a76:b0:781:7530:8b05 with SMTP id hy22-20020a1709068a7600b0078175308b05mr26624149ejc.489.1664348590221;
        Wed, 28 Sep 2022 00:03:10 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id kl14-20020a170907994e00b007813968e154sm1846647ejc.86.2022.09.28.00.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 00:03:09 -0700 (PDT)
Message-ID: <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
Date:   Wed, 28 Sep 2022 10:03:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220927212306.823862-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 00:23, Jakub Kicinski wrote:
> nlmsg_flags are full of historical baggage, inconsistencies and
> strangeness. Try to document it more thoroughly. Explain the meaning
> of the ECHO flag (and while at it clarify the comment in the uAPI).
> Handwave a little about the NEW request flags and how they make
> sense on the surface but cater to really old paradigm before commands
> were a thing.
> 
> I will add more notes on how to make use of ECHO and discouragement
> for reuse of flags to the kernel-side documentation.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Pablo Neira Ayuso <pablo@netfilter.org>
> CC: Florian Westphal <fw@strlen.de>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Jacob Keller <jacob.e.keller@intel.com>
> CC: Florent Fourcot <florent.fourcot@wifirst.fr>
> CC: Guillaume Nault <gnault@redhat.com>
> CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> CC: Nikolay Aleksandrov <razor@blackwall.org>
> CC: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  Documentation/userspace-api/netlink/intro.rst | 61 +++++++++++++++----
>  include/uapi/linux/netlink.h                  |  2 +-
>  2 files changed, 49 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/userspace-api/netlink/intro.rst b/Documentation/userspace-api/netlink/intro.rst
> index 8f1220756412..0955e9f203d3 100644
> --- a/Documentation/userspace-api/netlink/intro.rst
> +++ b/Documentation/userspace-api/netlink/intro.rst
> @@ -623,22 +623,57 @@ Even though other protocols and Generic Netlink commands often use
>  the same verbs in their message names (``GET``, ``SET``) the concept
>  of request types did not find wider adoption.
>  
> -Message flags
> --------------
> +Notification echo
> +-----------------
> +
> +``NLM_F_ECHO`` requests for notifications resulting from the request
> +to be queued onto the requesting socket. This is useful to discover
> +the impact of the request.
> +
> +Note that this feature is not universally implemented.
> +
> +Other request-type-specific flags
> +---------------------------------
> +
> +Classic Netlink defined various flags for its ``GET``, ``NEW``
> +and ``DEL`` requests in the upper byte of nlmsg_flags in struct nlmsghdr.
> +Since request types have not been generalized the request type specific
> +flags are rarely used (and considered deprecated for new families).
> +
> +For ``GET`` - ``NLM_F_ROOT`` and ``NLM_F_MATCH`` are combined into
> +``NLM_F_DUMP``, and not used separately. ``NLM_F_ATOMIC`` is never used.
> +
> +For ``DEL`` - ``NLM_F_NONREC`` is only used by nftables and ``NLM_F_BULK``
> +only by FDB some operations.
> +

The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
bulk delete to mdbs as well, and IIRC there were plans for other object types.
I can update the doc once they are applied, but IMO it will be more useful to explain
why they are used instead of who's using them, i.e. the BULK was added to support
flush for FDBs w/ filtering initially and it's a flag so others can re-use it
(my first attempt targeted only FDBs[1], but after a discussion it became clear that
it will be more beneficial if other object types can re-use it so moved to a flag).
The first version of the fdb flush support used only netlink attributes to do the
flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
finally settled on the flag[3][4] so everyone can use it.

FWIW the rest looks good to me.

Thanks,
 Nik

[1] https://www.spinics.net/lists/netdev/msg812473.html
[2] https://lore.kernel.org/netdev/20220411230356.GB8838@u2004-local/T/
[3] https://lore.kernel.org/netdev/20220411230356.GB8838@u2004-local/T/#m293c48e788e1a82aa77696f657004e8b4ab72967
[4] https://www.spinics.net/lists/netdev/msg813149.html

> +The flags for ``NEW`` are used most commonly in classic Netlink. Unfortunately,
> +the meaning is not crystal clear. The following description is based on the
> +best guess of the intention of the authors, and in practice all families
> +stray from it in one way or another. ``NLM_F_REPLACE`` asks to replace
> +an existing object, if no matching object exists the operation should fail.
> +``NLM_F_EXCL`` has the opposite semantics and only succeeds if object already
> +existed.
> +``NLM_F_CREATE`` asks for the object to be created if it does not
> +exist, it can be combined with ``NLM_F_REPLACE`` and ``NLM_F_EXCL``.
> +
> +A comment in the main Netlink uAPI header states::
> +
> +   4.4BSD ADD		NLM_F_CREATE|NLM_F_EXCL
> +   4.4BSD CHANGE	NLM_F_REPLACE
>  
> -The earlier section has already covered the basic request flags
> -(``NLM_F_REQUEST``, ``NLM_F_ACK``, ``NLM_F_DUMP``) and the ``NLMSG_ERROR`` /
> -``NLMSG_DONE`` flags (``NLM_F_CAPPED``, ``NLM_F_ACK_TLVS``).
> -Dump flags were also mentioned (``NLM_F_MULTI``, ``NLM_F_DUMP_INTR``).
> +   True CHANGE		NLM_F_CREATE|NLM_F_REPLACE
> +   Append		NLM_F_CREATE
> +   Check		NLM_F_EXCL
>  
> -Those are the main flags of note, with a small exception (of ``ieee802154``)
> -Generic Netlink does not make use of other flags. If the protocol needs
> -to communicate special constraints for a request it should use
> -an attribute, not the flags in struct nlmsghdr.
> +which seems to indicate that those flags predate request types.
> +``NLM_F_REPLACE`` without ``NLM_F_CREATE`` was initially used instead
> +of ``SET`` commands.
> +``NLM_F_EXCL`` without ``NLM_F_CREATE`` was used to check if object exists
> +without creating it, presumably predating ``GET`` commands.
>  
> -Classic Netlink, however, defined various flags for its ``GET``, ``NEW``
> -and ``DEL`` requests. Since request types have not been generalized
> -the request type specific flags should not be used either.
> +``NLM_F_APPEND`` indicates that if one key can have multiple objects associated
> +with it (e.g. multiple next-hop objects for a route) the new object should be
> +added to the list rather than replacing the entire list.
>  
>  uAPI reference
>  ==============
> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> index e0689dbd2cde..e2ae82e3f9f7 100644
> --- a/include/uapi/linux/netlink.h
> +++ b/include/uapi/linux/netlink.h
> @@ -62,7 +62,7 @@ struct nlmsghdr {
>  #define NLM_F_REQUEST		0x01	/* It is request message. 	*/
>  #define NLM_F_MULTI		0x02	/* Multipart message, terminated by NLMSG_DONE */
>  #define NLM_F_ACK		0x04	/* Reply with ack, with zero or error code */
> -#define NLM_F_ECHO		0x08	/* Echo this request 		*/
> +#define NLM_F_ECHO		0x08	/* Receive resulting notifications */
>  #define NLM_F_DUMP_INTR		0x10	/* Dump was inconsistent due to sequence change */
>  #define NLM_F_DUMP_FILTERED	0x20	/* Dump was filtered as requested */
>  

