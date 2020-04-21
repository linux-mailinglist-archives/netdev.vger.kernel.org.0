Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF7D1B1CF7
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgDUDhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgDUDhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:37:33 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9395FC061A0E
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 20:37:32 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id r16so2519292edw.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 20:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lcK4zwOZnJOI+uFwGayXktZObH7V4UGxNV57dIiQUO0=;
        b=hBxDS1AIbWYu3x+zMnegsGPM6fZffWXwOq7/7SAlQ6o1nsOhSksd4jDO7upi+hgoFZ
         7D5iQN/nX/uF5JcUDrDmASn/LLrN6HOn/qNOQwFL2lTp8TPQb7q0NkPgGm7mrzeC87er
         xL+Dac+VxsK32Hu9zqsle+wZ7+aK+SINwjth3mzND6VQfo7IeM9zcwA9AXc0vXc926h2
         8DXw4WipytgdjghdPwL0t8iiM+RTdxdW5ntFBQAGcboEzs0vV0nfNe9DMj+Q3I3AlEUi
         k5FNPyoAz/K8pLk0nwcpvKUMPeacCwJ1Ui+5Hj3NVZKs/uiA5sikHMnLpcmulrXbKzj/
         qnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lcK4zwOZnJOI+uFwGayXktZObH7V4UGxNV57dIiQUO0=;
        b=gGjrB0tnmuLupxmhDvvp0vRSertqSfoF3292U7Chjo1mvDyexl42ozxJS0IegHlAoa
         xpJ4OikszX46Dskp2NhP44jt9UPgr7brcQX+Gak+xZgt+my5OefDuA5ZjAsPa3lC/aQy
         bcmp2e9rLz+VcKpkHyDqISQyyjvijnTY1fAdIUM3u++SZcIJ6YE/RFikyrs/3UHfayr8
         deYvzCH1LjnMQIn4zYkVimnLwV5geKdSrTPICGXzJV7cVFQU+65gYgB3gh42bjK4Kbne
         GOHgYVR5kso/IEkCzCYR3A5iB05CBC9to4Tmppsp7M81n06S/jXD5WvDH9opXjMxEIca
         8VJw==
X-Gm-Message-State: AGi0PuZiNSX2xilkC1su8TfF+77HMmSnVjgkbxBW6l9JSXGWgzT1J+kO
        60bGUlsp35POKz2/yfe9BBc=
X-Google-Smtp-Source: APiQypIgep9Bm80PceY/VuQyKsUmL47s5uzqedCfy3ZAU2zAr+jdzbhyIiMaocOORXBVRiNgBxo3YA==
X-Received: by 2002:a50:a68a:: with SMTP id e10mr17545634edc.317.1587440251316;
        Mon, 20 Apr 2020 20:37:31 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r4sm337895ejz.28.2020.04.20.20.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 20:37:30 -0700 (PDT)
Subject: Re: [net-next 1/1] gwdpa: gswip: Introduce Gigabit Ethernet Switch
 (GSWIP) device driver
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Jack Ping CHNG <jack.ping.chng@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, Andrew Lunn <andrew@lunn.ch>
References: <20200421032202.3293500-1-jeffrey.t.kirsher@intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2ca0c449-ca84-05b0-2f9e-2c03a5996e91@gmail.com>
Date:   Mon, 20 Apr 2020 20:37:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421032202.3293500-1-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/2020 8:22 PM, Jeff Kirsher wrote:
> From: Jack Ping CHNG <jack.ping.chng@linux.intel.com>
> 
> This driver enables the Intel's LGM SoC GSWIP block. GSWIP is a core module
> tailored for L2/L3/L4+ data plane and QoS functions. It allows CPUs and
> other accelerators connected to the SoC datapath to enqueue and dequeue
> packets through DMAs. Most configuration values are stored in tables
> such as Parsing and Classification Engine tables, Buffer Manager tables
> and Pseudo MAC tables.

What is the relationship between LGM's GWSWIP block and the existing 
switch drivers under drivers/net/dsa/lantiq_gswip.c other than 
reflecting the acquisition that happened years ago?
--
Florian
