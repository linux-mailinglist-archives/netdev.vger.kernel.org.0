Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADEB493315
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 03:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344936AbiASCoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 21:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344789AbiASCoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 21:44:04 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D318C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:44:04 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id h23so1067763iol.11
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dWkLDh6NdDAYeltPq0c2CXjXvK05YocvsZNssmj1424=;
        b=d2ljkWr9/NVUu0ujNLDWBl9EDLZT0M6RWjLRGAXtFMVzAgtI3Mof2YJijHVhH4Z5h5
         w6Vw5IB1aRelnHP3OdhwfapA3WULJhcIV+CfHVjqMne82qaDF+jdcr788vK1RF/AUxCv
         qS9PevvRu/209MlSAQegmqYbdpLPnmzdPmF/cXwM4s82KNlVcsGu17Qy89jYDjtxClHJ
         pRt1VCglLB1iS5h1W7+MIyjhGb7v3l15mRW/osmZHACMLAVmFv15SrQXug1g5FbrSWwK
         2Z/miZktCW4kkqYEejbzInzEO1qqlQrcSoQ8X9UoMBNgdoCdcf1d1Glw7ixXJatN2tvz
         U0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dWkLDh6NdDAYeltPq0c2CXjXvK05YocvsZNssmj1424=;
        b=rZgOpjOUxNLlYQ8dAl7QaMs49+zl+FI8BYXJjWfA5ykJihxAm7EwN2gBjgsrmCsexh
         vJwJf1m5dmOH/WFP4NbaHtpNCduqL8cdNSFZkTJLaAMKA8QNospODZ2Gpt7YiyLHUftR
         ANHLdpRRqK5SI9nypvNxm85sGU3MCwwEVqCxT0GNNFpTecDh+zhPo3jyJk/shTZOL+7P
         kvp7mR2v0Nn8cOKP2XTlcxIiVa6a9dy/3hILIjrZxzjsfSL2INhyfQLUXuhqkt7gNsf9
         ReV6QDIgqYcwrgwZTOKr6adR+idBBHnxsi2/g3H/CHUTAi0bnVWKANMP9noFpMKMcyPr
         Pqkw==
X-Gm-Message-State: AOAM532SDUyvw/CmgSCtn770pHWpiaR0pTTG4QxlBG5G7UsL+1emxJAJ
        j+neye9yDKA9jriq2bytb6NJp0YxTUU=
X-Google-Smtp-Source: ABdhPJwDoQHsGGdZpagr2DtFmJud6UO8fiTbpc1Uny2DMcTguZjOnNblw8rganloDAElbITUu0bN2Q==
X-Received: by 2002:a05:6638:2ae:: with SMTP id d14mr12198440jaq.17.1642560243878;
        Tue, 18 Jan 2022 18:44:03 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id l14sm12523148iln.11.2022.01.18.18.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 18:44:03 -0800 (PST)
Message-ID: <0758f5ce-2461-95c2-edc0-9a24e44671d3@gmail.com>
Date:   Tue, 18 Jan 2022 19:44:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2] dcb: app: Add missing "dcb app show dev X
 default-prio"
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Maksym Yaremchuk <maksymy@nvidia.com>
References: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 4:36 AM, Petr Machata wrote:
> All the actual code exists, but we neglect to recognize "default-prio" as a
> CLI key for selection of what to show.
> 
> Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
> Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  dcb/dcb_app.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index 28f40614..54a95a07 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -646,6 +646,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
>  			goto out;
>  		} else if (matches(*argv, "ethtype-prio") == 0) {
>  			dcb_app_print_ethtype_prio(&tab);
> +		} else if (matches(*argv, "default-prio") == 0) {
> +			dcb_app_print_default_prio(&tab);
>  		} else if (matches(*argv, "dscp-prio") == 0) {
>  			dcb_app_print_dscp_prio(dcb, &tab);
>  		} else if (matches(*argv, "stream-port-prio") == 0) {

In general, we are not allowing more uses of matches(). I think this one
can be an exception for consistency with the other options, so really
just a heads up.
