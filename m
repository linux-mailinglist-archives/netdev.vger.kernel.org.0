Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700704677E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfFNSYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:24:04 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:42185 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfFNSYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 14:24:04 -0400
Received: by mail-lj1-f179.google.com with SMTP id t28so3313983lje.9
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7kbWLy/R4UBu2q7S3JoiO4taBHA/fRUiESD4ld36pEo=;
        b=PCQ67hbLxsyANnvKO+Y8z72RVkF6oXbGMqR+OK+ICiA5dSO5U+BwKiUE3I1+gTdvS1
         wj7vhgr070qq13icusP8lbfAxaNMkFMNXIUUvOyeeX6VJDkPAqW5kbQBtgjLwo3uF1lO
         C+7zYajFz4++X3f+N67gkzYBjaooisZE8hFwC4XaI9nn73WKjI0bfV0Y8406oFifcI/e
         NTU/XlPX37Ta7O7k8nfBbkKbn+VHHdONfFYtjIfnKlx4o8Ko+xTDwH7T/L9+K0qtc4DF
         tB71sACKZuA5CrcmshSW6p6ID/35PN7s6hFxLaAZj9AfDEejniI7vMfwiaAzLRpLyn0r
         cGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7kbWLy/R4UBu2q7S3JoiO4taBHA/fRUiESD4ld36pEo=;
        b=HCum/ZVcEWdmGalyzObJS2rXuI4A6n5hLivw5oHEeD8NfsivFoa1yenRd+qgYg2JDu
         rxMq2kds+z3f3A6FOSiy5O/yqxahZhmSY5mMMQ+MtOD/WYRCEkLcFm8BDqq6jzjyyjDr
         2w0SaB0skYmokkUx8Ig/KEC1mZ1P+CUF0gDI0vcsafqZRhyoYBWGCjnkoe9fKDDitj6N
         ADXw//ND7QU4gujQpQ4zepuRs79t/p0SKrCCWrhSwoa9ECLMhLcBy3ghMnFq+BBfBaP0
         NxF4FLFtN0wjMLlSoofMfTgXEp+ZAIpqEtmyGmJ1nYeo0nWRPifJsnHtEUowcbBr7kvP
         Yu4w==
X-Gm-Message-State: APjAAAVkb4ndIe8J62mnZkdGkAlzqrhTCINiZD58sFz9SXPme2Dhz8XT
        dC0W6mla08SKOwtgePLvEIOgqg==
X-Google-Smtp-Source: APXvYqyX81x3Q6I/k3CYnukX3N2hrLX2F9QQio1ii1g4g8vVpY0DS33rDNHOVCy/gCaS0gsu1daa4Q==
X-Received: by 2002:a2e:900c:: with SMTP id h12mr24014300ljg.197.1560536642588;
        Fri, 14 Jun 2019 11:24:02 -0700 (PDT)
Received: from wasted.cogentembedded.com ([31.173.84.145])
        by smtp.gmail.com with ESMTPSA id v14sm706702ljh.51.2019.06.14.11.24.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 11:24:01 -0700 (PDT)
Subject: Re: [net-next 12/12] i40e: mark expected switch fall-through
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
 <20190613185347.16361-13-jeffrey.t.kirsher@intel.com>
 <32dbb5fa-7137-781c-c288-88055d0cb938@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <3c447eda-2a7b-3d1f-2e15-f2f2f2fa7db8@cogentembedded.com>
Date:   Fri, 14 Jun 2019 21:24:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <32dbb5fa-7137-781c-c288-88055d0cb938@cogentembedded.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/14/2019 12:36 PM, Sergei Shtylyov wrote:

>> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
>>
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> This patch fixes the following warning:
>>
>> drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function ‘i40e_run_xdp_zc’:
>> drivers/net/ethernet/intel/i40e/i40e_xsk.c:217:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>>     bpf_warn_invalid_xdp_action(act);
>>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/intel/i40e/i40e_xsk.c:218:2: note: here
>>    case XDP_ABORTED:
>>    ^~~~
>>
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> This patch fixes the following warning:
> 
>    Gustavo repeats yourself. :-)

   Himself, of course. Sorry, hit <send> too early. :-)

>> Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
>> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> [...]

MBR, Sergei
