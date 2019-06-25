Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231575558D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfFYRLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:11:01 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:33668 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfFYRLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:11:01 -0400
Received: by mail-wm1-f53.google.com with SMTP id h19so2754081wme.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j8egm+f7uYFeozrmdtjTbkUEX+jFNL5scBIkxSRE180=;
        b=KXq7xeGLLTI6xgbs6EzyDmnSf51OdC3zlaDBX7/zxJLzHumtXqTNF4/MMESHpb+Mlr
         jKjsEB+DpGGTxLRFM83E7DGUZ0b8//3p6CO3z1bEUv7L4oauwjsCRA0b7D9ehaUlrilo
         XNCqwzSm7pixaoR7FciZP4x2TtHfkNTQIvIubjAypbB/R/4zvSJdXWp+G5/BhK2exdGQ
         j2knz0nZP4En+ELQgel+0Ry9odrBqsCZ1k+1coSelMJZuBqk1HZQYfO2XvR3CSyqgpdH
         n3sl+pTj5jgGL87iH+oWIpTEVih5T6Csokylv3BM/Ya/0mjTpMw7LwLQl3Q/PGCYBJIy
         aklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j8egm+f7uYFeozrmdtjTbkUEX+jFNL5scBIkxSRE180=;
        b=tmI2mEq8LGSaF1vZ3K2l5lpnS7EHH648Ka1GupzGbQWLSkim9GQk4hZ+j/ol2uTZpm
         C5HdLs16nUZOH5h20nWDwVeCd+zbVEX2HC7AKb3i54CgvnaAsG4RkxyXCcvgPpbhR9vv
         BvLRhi+ClfdrLuvw8VtNDPdQ/t6jkHQ0IBpf6E6efuzTrkfzzDwQsOsFmXGdZyjMlEeU
         k0DTPlgPu+DIdhGiWpu4A3JlRHemfCXsmvXm9eplWb80Kg1pjDZwlx2zSNgbtCUVDYoT
         AsvJPmu4hj6xkZV0JOdnQrl7Jj1ME8HujG7UPYMmHQcI/CgSDNRcQR8djwNVw4qiW+aA
         CmTQ==
X-Gm-Message-State: APjAAAVJjgWt4TV1cjA1r/2deC08Dhg6zIKgT5JYROnM2VfKIFmBiGaH
        ZrFcQGqbLZWNQj8P0AahTqiGCErs
X-Google-Smtp-Source: APXvYqytb1OoI9q4YHTQmVfAunJlzl9TlSTvsD/ZxmxaclOg/dGa3sDHWyKAXMx9YNqf4Pavf9NZXg==
X-Received: by 2002:a1c:b604:: with SMTP id g4mr21020795wmf.111.1561482659328;
        Tue, 25 Jun 2019 10:10:59 -0700 (PDT)
Received: from [192.168.8.147] (104.84.136.77.rev.sfr.net. [77.136.84.104])
        by smtp.gmail.com with ESMTPSA id f2sm20766632wrq.48.2019.06.25.10.10.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 10:10:58 -0700 (PDT)
Subject: Re: Warnings generated from tcp_sacktag_write_queue.
To:     Chinmay Agarwal <chinagar@codeaurora.org>, netdev@vger.kernel.org
Cc:     sharathv@codeaurora.org, kapandey@codeaurora.org
References: <20190625130706.GA6891@chinagar-linux.qualcomm.com>
 <ab6bb900-e9b7-f2b2-0a56-d1c9e14d2db6@gmail.com>
 <20190625155734.GA31551@chinagar-linux.qualcomm.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <39967cd1-a44c-1d2a-6004-95bc8fca3fbc@gmail.com>
Date:   Tue, 25 Jun 2019 19:10:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625155734.GA31551@chinagar-linux.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/19 8:57 AM, Chinmay Agarwal wrote:

> 
> The kernel version used is 4.14.
> 

Do not use this old version please.
