Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906B62F7E00
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbhAOOUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731501AbhAOOUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:20:21 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EDBC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:19:41 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ga15so13544191ejb.4
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4TsqQE7yk0QuUCQaSCKor5Gzz+dsIFwtHbAKqkNHbME=;
        b=g+I/dIZVGGEMQf/x02S1jnX7Gz7WZSH/qp7ALUhoztgDAdtrOSXP6DO6lQjvChUcoD
         Thx2rdP5PmWfGeKwygg5RH4B+Q5vAiOeN/+RLEEWPZeHepiSnnnlF45ANk6I5ggRtZ/0
         XSUau5O9IN2MhxokjFUs5QkDpL5rHqXTzwPadXrAA2JN9fBmkUuF2KpkQrDYpwJ42MAW
         HC38z+l48md3uTVmI47HQrMn+oGpk4Cv/l4hVRqW53epAMg/n+Q/dRzUB3BzwbTmIYyn
         eGB3JvvJsvVxcKY+kgn3wq4ysISXiM/tZZZ/jbHEfq7l36qKPJy/IBe3E+SE69pdlffB
         lkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4TsqQE7yk0QuUCQaSCKor5Gzz+dsIFwtHbAKqkNHbME=;
        b=FtyGkz78TbsgrXJtKc0UTWGT9gmedjL2gopeewnjnZ4gNodyZRRNxGhV0xO5nViZui
         XZIEw8I72l54oOoe5EYFBv9CGgY/fEDOhNwPx3TiaygCAKRlfL1nGeXJd64w8UqhIBa0
         dQyxYillMJ64UaQeqcU4/Mj/jn5OP0/lZsyzvjDEmeEZneYIwraZf9vN6+GiKDa1LltQ
         HplBd7X4xhqQ2NMPp2cfLk6OdO0JZcslx8PE8z9OvnHxjKkvMHG50xXE1u9DJsJV/9z5
         BLfAdICRTDFyPg4hwdQLOlCHbJD5IHCs51e5BxVCWxyYT2hyuwiFS5sw/ln6o/JWlKs+
         7I3w==
X-Gm-Message-State: AOAM533VbuEGMOjnvypdZes7Hu9UheOEEOCePVixPypqnMpRRVQIfzj5
        Dx6F0wsCk0pyXw4MSGmds/trkA==
X-Google-Smtp-Source: ABdhPJx0bV6REVytA35aXGOXUExmuG5P6U9MhicaG9m8bozw7/8guedFKj3B0vpXSVTmhoN+kh5w+w==
X-Received: by 2002:a17:906:fb9b:: with SMTP id lr27mr9297735ejb.175.1610720378630;
        Fri, 15 Jan 2021 06:19:38 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t9sm3543694ejc.51.2021.01.15.06.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:19:37 -0800 (PST)
Date:   Fri, 15 Jan 2021 15:19:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210115141937.GL3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210114073948.GJ3565223@nanopsycho.orion>
 <35d85fb0-a3db-e0c4-ca5a-f3e962c3dfbf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d85fb0-a3db-e0c4-ca5a-f3e962c3dfbf@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 14, 2021 at 11:56:15PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 1/13/2021 11:39 PM, Jiri Pirko wrote:
>> Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
>>>
>>> I assume if i prevision for card4ports but actually install a
>>> card2ports, all the interfaces stay down?
>> 
>> Yes, the card won't get activated in case or provision mismatch.
>> 
>
>If you're able to detect the line card type when plugging it in, I don't
>understand why you need system administrator to pre-provision it using
>such an interface? Wouldn't it make more sense to simply detect the
>case? Or is it that you expect these things to be moved around and want
>to make sure that you can configure the associated netdevices before the
>card is plugged in?

That is what I wrote in the cover letter.
