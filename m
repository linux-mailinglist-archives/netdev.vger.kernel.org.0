Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443F4ECCFE
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 04:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfKBDBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 23:01:38 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37583 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfKBDBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 23:01:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id p13so5145252pll.4;
        Fri, 01 Nov 2019 20:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EjWmH7c40hv68dxdshtpr5niNeilJLAYp4ltJWbDHs8=;
        b=JAH37N/df/EcgeYQfpHyDAZvKSb/ZR0MdnzmXJkKYauWno7oejE8t4VueJITh0VwZY
         Naf2zF/gN5S/qno278qCDBj8Uxep8IQuLk94bFcPw9CQxnSs+4Wouqq9j5dslZXhPu4u
         P0LjVXb9pdjuQTSDspMZPgNLz6G0julj2gpAhUpSZQuJiTmbnfvLvWrmTa7GH4BwCC4x
         zcL3IaxA7e/r/Q1zGskuXeAMu3orSXX9YgssbFN/TuuZuNXvi1HHHaQYbct+/aU+8O33
         1a/pOMpI/LkV9vEMWHdMCp8kK03esXa5XHPQ0lXylSxg7ZXmOjeKcA5j/uRtSW1KVmDc
         CCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EjWmH7c40hv68dxdshtpr5niNeilJLAYp4ltJWbDHs8=;
        b=ksvLmfx5r7oktlgyqrRU1j5VxWXQvvVPiBugxmNkvUhhNWAhj5Xze4vmslVXeE7BQn
         QnSfBds/qGmzJvUlxLAGLaa3+qG9ZCQNPlM6S2PAp5+R8d1sHWcYPF38S5QoLcV/Z/Cw
         3SP50ZFOWiLoZSxQLcIKQzfCXZpGPPD+GbN6wm72q0rvoHxOinYf0Q9ozvbhb8VdnMzU
         0a153u54za6F8oO1q4jGGsHrnS59XkhpO/SH++51vmQFGZSShF3JHy8sPkE95tC856f6
         jt0lWyyxgrGKsdf5qf1p+aEnfeTflu7+OB27iOt1StvU8MY2j0zQO/tVZpePcQwxUJg6
         94vQ==
X-Gm-Message-State: APjAAAVafcF+q4IvGPUJGdSCUQ7w8f+nhKnjVpt+sX0dEnzX1HamO2Tu
        MnvjYYDRvpkdVVRR6LcsH97izVOT
X-Google-Smtp-Source: APXvYqzGSPp9h55RP/UOjndogWg5NJIjr6BNtSuFue3n0bFtjgaOE+yRePf7nHg7nNpem9RmLpUxRw==
X-Received: by 2002:a17:902:8f8a:: with SMTP id z10mr15369660plo.314.1572663696932;
        Fri, 01 Nov 2019 20:01:36 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d4sm10396332pjs.9.2019.11.01.20.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 20:01:36 -0700 (PDT)
Subject: Re: [PATCH 3/5] net: phy: at803x: add device tree binding
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
References: <20191102011351.6467-1-michael@walle.cc>
 <20191102011351.6467-4-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c93547d6-27fe-b4eb-d490-481a01f0b57a@gmail.com>
Date:   Fri, 1 Nov 2019 20:01:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191102011351.6467-4-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2019 6:13 PM, Michael Walle wrote:
> Add support for configuring the CLK_25M pin as well as the RGMII I/O
> voltage by the device tree.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
