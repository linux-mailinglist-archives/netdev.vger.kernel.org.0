Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8CE1A6DB0
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388688AbgDMU7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733294AbgDMU7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:59:32 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0209CC0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 13:59:30 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e4so7591884ils.4
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 13:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TMbpwzCbmL5TNMLVe9M+LvhmUMUVDgWr26CnbYGOEu8=;
        b=yOWJulkg5LyH/7LKLYgV+QrU17nMGQoIV3wbhuIbcONY+8wl/33TLG+ugglpg/pAM3
         +An+hcvvm33sQMOzgzSCVDSBekCHOmlehr6dORlx3TnnS1K8BmBPNNx7nx7BTilNol7Q
         H70qQXOZgiqlip/Gq2A9h/V8gLUQCtmWi5ARUYDM5Pfykpc5yYegXYO3Gm9fwsF1R5Zx
         Ny7dvzudOQP23nDqQnc/XQpMIxA3UEGUwOfOgWzeWhkgcqyU6qK7vYvVZ88nf8ph96nY
         xRt1rk5kTPE46Wuj7Akm9fKi6JFRiAQpHDPmGkBMRicCdgEAKfvV1qFl566wJ+HPHtKb
         IkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TMbpwzCbmL5TNMLVe9M+LvhmUMUVDgWr26CnbYGOEu8=;
        b=LEyBlm+G0j6pABWF+YnN8W13Ma0mdGwWUU6yZYgu2icHCX81KQ2VjW3KPUu9nFECPO
         JR9DN9cH2r0++1Sk2bYSEG4ApNa3XCGjcpLbMPFKEWQRQs95by7PZ31CPluXp6FcNAFy
         17/nVJOu531244Ysn6XHCPvS+hVGxfWtvKozpxk2WybyjRhwF9HxzlUaZqJyhVsEciwC
         WDI2N8kfO2QN1aVrxZzCfEUV8r4BlgSFY/V/CvPbkmhjXEGT+L4LGA+wePTrknhccdNf
         GUvaRr2dsKMObv0KUQsk20iDKEhpaLf8uaaH/F2eUK5LtXiAJ4fUajMMNpAD6pJB4CUH
         /D8A==
X-Gm-Message-State: AGi0PuYSjAqN11rG2Uf8OEeARw0s/y2rb3AcpBVhzmskahtTbdFiWDEb
        KivdMhahlpsvpCPl1tCzzTz1Ns2Ga92Gcw==
X-Google-Smtp-Source: APiQypJWbaRP4LtJPSaLV4lo88+/ybBkp+KZzWIOx+qQvgBjyFnOk1tlcUoz65GVH+CrOjShNKt+HQ==
X-Received: by 2002:a92:3b9b:: with SMTP id n27mr17479919ilh.159.1586811570095;
        Mon, 13 Apr 2020 13:59:30 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o7sm3701420iob.32.2020.04.13.13.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 13:59:29 -0700 (PDT)
Subject: Re: IPA Driver Maintenance
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <cd3cefcd-1b80-d788-38c0-7d2a03fb6a0d@linaro.org>
 <20200406.120430.52263128980646881.davem@davemloft.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <4b55a500-4315-f612-e530-3509f2d94b49@linaro.org>
Date:   Mon, 13 Apr 2020 15:59:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200406.120430.52263128980646881.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/20 2:04 PM, David Miller wrote:
> From: Alex Elder <elder@linaro.org>
> Date: Fri, 27 Mar 2020 18:42:13 -0500
> 
>> I'd like to know what your preferences and expectations are for
>> me maintaining the IPA driver.
>>
>> I will review all IPA-related patches and will clearly indicate
>> whether I find them acceptable (i.e., Reviewed-by, Signed-off-by,
>> or Acked-by... or not).
>>
>> Do you want me to set up a tree and send you pull requests?
>> Should I be watching the netdev patchwork queue?  Or something
>> else?
> 
> Patches always work fine, as do pull requests, so simply do whatever
> works best for you.

Sorry for the delay.  Patches are easier, so I'll be doing that.
If gathering patches for a pull request seems warranted at some
point we can switch things up.

Thanks a lot.

					-Alex


