Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16DF169EE4
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgBXHCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:02:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41660 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXHCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:02:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so8986949wrw.8
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3oO9LdaDkUb+0hGjr6jAjsrZrAjI19aWDb4hbRbnuaE=;
        b=EsEpzn2HHhzqo0EIEK4PfMiMcBJJ4+/9VeqUhdFFFiz/yIBAe+kIMMk4jM59I5tVrz
         aBys1us1Iel2VL4FVEhcGuXhyoTXkZUHgnU+N+s6cmgw9VWyVS0vg9VmK9AyOzLfKAT8
         WkMhLk8zQUfr0fT1PMHR4b1KVCZ9uJgtWZPyUfG3hFjNF3HPGmlmIrotE/cL6Flv2KB+
         /XnNUdVIPShL6O5B4sAxiS8o0fpJrG5pph2OT5Oh/gcNKOXLgiTkBkxE5K4E84oa421A
         zGJvKA02JoGthudbMXOkOW7GifrDUGRKdfYBu5dJwHLMSZr7zt8K5tRWq6I9Od6GJkFa
         gpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3oO9LdaDkUb+0hGjr6jAjsrZrAjI19aWDb4hbRbnuaE=;
        b=NGeHxfO7UniZbtk93AVRgIO6tkVTZf3akhIprZTCskhs/VEuNF01j54lNIzdD4f0bw
         l0PLB3loOgmy9XbC5xARhjlXrqsfqr08WTsB21L7fhDIEf1X3+VXyBRL3Gv03XURQ7iB
         5aOJPXpb/0n/Lj7QxHxHwbvzDDG0s0fa34+COoPem8s2ULDemIGOmEuQ3ZK3+sbF8eN5
         vZ7LVbseUA2TTgsNFyAtt9/rhkA0mFWjSfkesKnGp9s/yfhrBWz6Sn+4sVulzzhCdx6K
         VApLYyI3i038mzyzwcJa3f0JKWgyNhXLcVF7KW67QGTfh2XoN3cHIvHnb217D5WuWPIa
         +h7A==
X-Gm-Message-State: APjAAAUo94SikMGqJPL1EKGPgjE8lCYOG5d0oWHykTNiat94WmnzMsGW
        FHJuIN27XNjuV/rZufYwQtkgVg==
X-Google-Smtp-Source: APXvYqzxV/alViSQMOvg9tweT1vy9Pic4/BcCj+ChkhktRArv+jPk0j/9UuLQ1L+2SCrsA8o71zfHg==
X-Received: by 2002:a5d:4f89:: with SMTP id d9mr64929908wru.391.1582527750045;
        Sun, 23 Feb 2020 23:02:30 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h18sm17912506wrv.78.2020.02.23.23.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:02:29 -0800 (PST)
Date:   Mon, 24 Feb 2020 08:02:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 00/12] mlxsw: Cosmetic fixes
Message-ID: <20200224070228.GA16270@nanopsycho>
References: <20200223073144.28529-1-jiri@resnulli.us>
 <20200223.161311.2119739902658169966.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223.161311.2119739902658169966.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 24, 2020 at 01:13:11AM CET, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Sun, 23 Feb 2020 08:31:32 +0100
>
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> This is a set of mainly action/trap related cosmetic fixes.
>> No functional changes.
>
>Series applied, thanks Jiri.
>
>The final patch removing unused PCI values didn't apply cleanly and
>had some fuzz...

Ah, you are right, there is a patch targetted to -net in our queue
changing MLXSW_PCI_SW_RESET_WAIT_MSECS value. That's the reason for the
fuzz. No problem.

Thanks!
