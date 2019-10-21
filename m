Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3364DE267
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJUCzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:55:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45015 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfJUCzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:55:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so6816260pgd.11;
        Sun, 20 Oct 2019 19:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n6q4nAKjxfy0IGRBzsfdgwCjetx208YR00SKYdDf5L4=;
        b=STNF+qMPIQVPczXkdxKSlD7w9+m12ligvY2hSWRH95O1dBrIYa8s65d5s0K+j0aGEp
         zK7nS69ITUiG2UPwpir0lbHWtBx9pDycufLrMR4HJ2iUsZAkcodVzE0mMf9FDneDwllI
         p8Dmb4cHjDYiih54GyuFarAY80k/etNSoEzlOhqFDZwntIqf2Y07e4zLHaMfLzlEcdvB
         2Cm2KKkaIY+MGHCuv4yCVHHV4xAbZp8mc64d2ELeFRcs+2I7YhSt9qyDKmNWR/MfEpWa
         K7bqKQfGhB2CHGvnMFTjKYSBsPeXbFH1rEP0b5z+AKTsLFz3rlS8Q8jA9nXx9sEe7E3M
         jmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n6q4nAKjxfy0IGRBzsfdgwCjetx208YR00SKYdDf5L4=;
        b=O9pmNxzZNImTa4/M9RZ1QhCYeJo4mJdSc/xDA19EvAxVqq4VQa2XySbEUrcuC64OCM
         fRy7W0lGzZhDjsEGmWR6bGgZ6JsueE22pO5VEe+BnOlCKFDGxWIwGOAXxRjaCXhN1O0R
         VmyJM4ODW1S+gmuDt733FbmmipgDlYdf1+gjKnaa+ovk2OQGMSr1zWeotCGaRhcPmrl5
         wigiOgcV34Yyf6Ik4DhiJoi1pIaZMz57ldmuCoEDHM7QT7thJuCcVYJo4ajAGp/CeaK7
         7z30eKfCYst6H8Hs1ftOp75UOmu+fwm9Kb6w2K/G7MPoDoS0c4sh9Zb3pb6pBRbi+meN
         VjQg==
X-Gm-Message-State: APjAAAUhH+fsTwIgAg7S/ZWnsFEueksEoEAm7Vzl1fs4MAvIgQ6K4syI
        JzUZJMnMqj1QoMJI3m6Mk1GuxmAx
X-Google-Smtp-Source: APXvYqzoI9MAdfH9YKyZ/mCwnnw1W+NHkvwtkREsYGpI9gnh7v1OzvFFXJehGB/SrxtG/xhv2FRKLw==
X-Received: by 2002:a63:f854:: with SMTP id v20mr9155261pgj.92.1571626513214;
        Sun, 20 Oct 2019 19:55:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b22sm12988674pfo.85.2019.10.20.19.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:55:12 -0700 (PDT)
Subject: Re: [PATCH net-next 16/16] net: dsa: remove dsa_switch_alloc helper
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-17-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c271fa76-5740-b30d-7d26-8183ea059d72@gmail.com>
Date:   Sun, 20 Oct 2019 19:55:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-17-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Now that ports are dynamically listed in the fabric, there is no need
> to provide a special helper to allocate the dsa_switch structure. This
> will give more flexibility to drivers to embed this structure as they
> wish in their private structure.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
