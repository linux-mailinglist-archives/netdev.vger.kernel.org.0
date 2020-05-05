Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B711C5DD4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgEEQsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730069AbgEEQsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:48:47 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AABFC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:48:47 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k12so2532710qtm.4
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Np1YJxktt/cQII+KKcpJcc/p6vuOqy7nN6Elnc7spCo=;
        b=M0086J0Tv2CqZMkcX4NvMsBkb0V765PYb+qLMmPdvY1eprhHTa85RUuMHlb9UpBJ+Q
         vcYtltvFfAuHe35MubXRzVgMyuMDrgnix6HGjLrv5OWBgKPT+1OTSVixNTVCBV7YgNLp
         ke6LmiU1DzsrEvJ6CzzCltdHxsS9e4YBTMNz8Z74HDwkRybekz7yONiIMwS3QBUj9tR6
         eSBXUq3PpCm9fwUiFobXyf2EL7B/FSNd2UCiTJG0zMW5orzOJgy/nz1bTI4HjSpCvt/M
         7Gl5yyxu1ncKgK4/kJ3I+oI1w3xZIulX6XhIEdUnwOxcDD6RPVYSQVi7qR8d01/PzC5h
         LPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Np1YJxktt/cQII+KKcpJcc/p6vuOqy7nN6Elnc7spCo=;
        b=ODcWc2u3fLt8bGnckkvk5FEnTYVPCyMGFdrGmud/O0LEyXly67zTgf1PIHyVFEptg8
         JDJ4bt9WQKqGHF3El3I3B0qW9p8W73Gxs1FOjeGlplg98jfOYObabAr1zaJmp0bJFGIE
         nPdnvQR7CYlnCw7KCMvAVyiSg+kyg2GqBlvbcc91CukKvbSpmJqtdu/U5/cav4tDKIy/
         Xm4s25i3Pz8nR/LrzX8qgq0SjLblqVMUHUH30w+ixDKsAciZcoxVbb2DIZoeuFCyusGC
         xO3qXm+GxBm6qOL1gxi+o1tCPJSAqLplVeMPI68F79VEfFZszMQLRdkwSY1Se1PSRtV5
         KIoA==
X-Gm-Message-State: AGi0Pua0MXBEa99TbbpF0oRuOcapYGk4xRbWjyDm0prG0ajroJmcKxxr
        khEe0c4T76I3iAunZDvZV40=
X-Google-Smtp-Source: APiQypL09nJHRf+ro29J0obRB/yStfis5JEVqyK9Y4Bm/4khyFlny2GlbeWvStioIku7xHT7WMDbZw==
X-Received: by 2002:ac8:82f:: with SMTP id u44mr3578688qth.198.1588697326481;
        Tue, 05 May 2020 09:48:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id o201sm2223775qke.31.2020.05.05.09.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:48:45 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 2/2] lwtunnel: add support for rpl segment
 routing
To:     Alexander Aring <alex.aring@gmail.com>, netdev@vger.kernel.org
Cc:     mcr@sandelman.ca, stefan@datenfreihafen.org
References: <20200502225834.28938-1-alex.aring@gmail.com>
 <20200502225834.28938-2-alex.aring@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <91fa6efb-1284-7f85-e2f7-627c349d5b76@gmail.com>
Date:   Tue, 5 May 2020 10:48:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200502225834.28938-2-alex.aring@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/20 4:58 PM, Alexander Aring wrote:
> @@ -162,6 +168,32 @@ static void print_encap_seg6(FILE *fp, struct rtattr *encap)
>  	print_srh(fp, tuninfo->srh);
>  }
>  
> +static void print_rpl_srh(FILE *fp, struct ipv6_rpl_sr_hdr *srh)
> +{
> +	int i;
> +
> +	for (i = srh->segments_left - 1; i >= 0; i--) {
> +		print_color_string(PRINT_ANY, COLOR_INET6,
> +				   NULL, "%s ",
> +				   rt_addr_n2a(AF_INET6, 16, &srh->rpl_segaddr[i]));


you aren't printing anything for the json case?

