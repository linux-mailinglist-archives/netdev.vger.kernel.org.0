Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55AE110019
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 15:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfLCO1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 09:27:51 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:46185 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfLCO1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 09:27:51 -0500
Received: by mail-lj1-f171.google.com with SMTP id z17so4000399ljk.13
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 06:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=guyU9pjK4wfyI0zxTwawVULlw/acrkACnXckcbvyzCg=;
        b=hXeqLKd3Ex+gD2wlQE8Y9aD1QaPVq5ll1iwNoW2f2zE+dL8LVt3mv8uRymq/T5/Bkx
         j8N9JJVg1stwy6BHhh1lQLOGL7hnv8xbkZWuZW+GQr6C40J2GWkl3Ei58Flfwhfqcm7h
         U4M+2bmUxHIkCy535YnjpUvWNbG1VUmOCiRyRQ+/JDK4xqfNarXNTMoFchoMCa7LaDXv
         U2kr8ZX7PJqrY2/NWa0LYD3zOXOTBkNAoAR6LzwlQHMpOkDgFMoabcKoVE0kRaQIeYoC
         DzxZD7pCbNE6CL9jUVgTTvHc5J9tYGqb5VcavklHeac/1IOUyo34EJpySuCJkheNVqWy
         rUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=guyU9pjK4wfyI0zxTwawVULlw/acrkACnXckcbvyzCg=;
        b=I4FZd7k3ZTEEjebk922uxAqbDkFqHAbni/nUfpIEnxbmXz8JAv3x60hAHGORvvd+4s
         91OaFDz9iuQcmOYRO6FniwKCqeAQH3zY8J2L4dahX7BLJk2NuSNicbyVG0ka5J8zl+i9
         TEIihl7DMk/cORdbud8OFugVvWaJCsjsugUS3nu9scsB1iExhuJ95WPGfeUJe8ikiDO4
         iJ41+O1rzC8lwnJUjiR/IO+/3p/NvPp/iEpUpWUDqMshFN0donxbadgUDnDVP2JYFaKB
         b6R3h7frQZvUFVrpVF2Q9MKp/TyfnJ2vemuN3X7rgUwyxGAiF14dxk03R/wQ/TbLhxoZ
         MoSA==
X-Gm-Message-State: APjAAAXxpm69PfvIWBe49dz7rcIkRdyhNZh7JpSw2lJIYuPKFI4HTQUz
        AbuPJ3f4S4jNwA04dTh6p991sQ==
X-Google-Smtp-Source: APXvYqybNVCk142Ft6t9aAgpS6eH1ribycSCK05SSflnhb1uPvooA5D2TpEV49C1+BbdQW27J8jnUQ==
X-Received: by 2002:a2e:b010:: with SMTP id y16mr2858547ljk.238.1575383269361;
        Tue, 03 Dec 2019 06:27:49 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id t143sm1452139lff.2.2019.12.03.06.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 06:27:48 -0800 (PST)
Date:   Tue, 3 Dec 2019 16:27:46 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: tperf: An initial TSN Performance Utility
Message-ID: <20191203142745.GA2680@khorivan>
References: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 10:00:15AM +0000, Jose Abreu wrote:
>Hi netdev,
>
>[ I added in cc the people I know that work with TSN stuff, please add
>anyone interested ]
>
>We are currently using a very basic tool for monitoring the CBS
>performance of Synopsys-based NICs which we called tperf. This was based
>on a patchset submitted by Jesus back in 2017 so credits to him and
>blames on me :)
>
>The current version tries to send "dummy" AVTP packets, and measures the
>bandwidth of both receiver and sender. By using this tool in conjunction
>with iperf3 we can check if CBS reserved queues are behaving correctly
>by reserving the priority traffic for AVTP packets.
>
>You can checkout the tool in the following address:
>	GitHub: https://github.com/joabreu/tperf
>
>We are open to improve this to more robust scenarios, so that we can
>have a common tool for TSN testing that's at the same time light
>weighted and precise.
>
>Anyone interested in helping ?

I've also have tool that already includes similar functionality.

https://github.com/ikhorn/plget

It's also about from 2016-2017 years.
Not ideal, but it helped me a lot for last years. Also worked with XDP, but
libbpf library is old already and should be updated. But mostly it was used to
get latencies and observe hw ts how packets are put on the line.

I've used it for CBS and for TAPRIO scheudler testing, observing h/w ts of each
packet, closed and open gates, but a target board should support hw ts to be
accurate, that's why ptp packets were used.

It includes also latency measurements based as on hw timestamp as on software
ts.

It also includes avtp and bw measurements with priorities, you've mentioned.
Now I have branch adding runtime measurement with plots.

-- 
Regards,
Ivan Khoronzhuk
