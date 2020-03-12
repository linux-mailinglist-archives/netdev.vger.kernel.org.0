Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BADA18274C
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 04:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbgCLDKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 23:10:05 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35547 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387692AbgCLDKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 23:10:05 -0400
Received: by mail-io1-f67.google.com with SMTP id h8so4187820iob.2
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 20:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7UlCPqaifwtaHRBNM9OlkA92uhGP3P8YtjrPHhM2qXA=;
        b=MymNgzFAjC7botrqgoNNcIOUuAsnEj/YaRhp929DK9qF9NTSCoVLgqQuyUlCuuWbmc
         xTX8qnat5Lhd0dx2+HvITd9I3p8W2oFWYYiLmPSxLhHu9VDmI3IenMvfEFdho/S8vd2I
         yuLM73a7S/wx1yoSfX+QL5qO2LsLHWifPuA0hRfAhHp4rftW0kW6WLVBjS4J0fyOpN3O
         7r/1++AmSjZryTn2MxF74XgpKzfez6QsJWgBfcCvVchXvT9agRNixKTJPc0eob3a5Q1X
         xoLsGG5eL0WYwn6be71SqmjgQeJZ5NZqTQtoyqlEcSz37jy3pIQVaP16SIN7GWzqFG9X
         3jyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7UlCPqaifwtaHRBNM9OlkA92uhGP3P8YtjrPHhM2qXA=;
        b=IbslklSqbCI/4/3XUGJoii6Jc42aWUo0ZyM9A29nWQbgQ0mi/03LnLzQaknQJQlP9L
         xa29VYlGGCOsIPiRwuyMU68nOiJ3mnzTM3l1nbboVjCNTtlF7//hdzozS+oAkfmF/Ya8
         T26bPZsfZhyAF/z54cOyzyrnob2Nqt9BxrmfPzaNlI/0ZW2zEIfm0o3RTrT07feUJ4TF
         t1pKi+3gBLZqYGFyETT/1IoigV8OyqlAVRVflHNx39tFprM+Ei02vMCnHu32ma4V8iJF
         PJkzI7ZHBK7oei3dV61YopOgOgJDXM/av4Em+tpGPywuerI7uAKlHP+h5yZd6mmN2gPR
         iYOA==
X-Gm-Message-State: ANhLgQ0U2y0AyVnRUvdXN47gsg/cv9xR81xcF++BAfLT4KeEiwh3Sxrz
        98+Zc2+J5CsC8Ci9K73k59DQVA==
X-Google-Smtp-Source: ADFU+vs/imBUNrCpmlxjMLXtYVDj0Q3NbjhYgAeR0ptUEQhLsK2b4DLsRH6n4QvzTYidB9g45CZyjQ==
X-Received: by 2002:a6b:6606:: with SMTP id a6mr5411023ioc.8.1583982602672;
        Wed, 11 Mar 2020 20:10:02 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id y18sm12685362ilg.82.2020.03.11.20.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 20:10:02 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver (UPDATED)
To:     Dave Taht <dave.taht@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200306042831.17827-1-elder@linaro.org>
 <CAA93jw5enz6-h1m=7tGFToK+E+8z3aD80pBef4AYkFrS2u3hHQ@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <e4f436b4-3dd7-970a-9b08-7601fc5428d2@linaro.org>
Date:   Wed, 11 Mar 2020 22:09:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAA93jw5enz6-h1m=7tGFToK+E+8z3aD80pBef4AYkFrS2u3hHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/20 11:54 AM, Dave Taht wrote:
> I am happy to see this driver upstream.
> 
>> Arnd's concern was that the rmnet_data0 network device does not
>> have the benefit of information about the state of the underlying
>> IPA hardware in order to be effective in controlling TX flow.
>> The feared result is over-buffering of TX packets (bufferbloat).
>> I began working on some simple experiments to see whether (or how
>> much) his concern was warranted.  But it turned out that completing
>> these experiments was much more work than had been hoped.
> 
> Members of the bufferbloat project *care*, and have tools and testbeds for
> exploring these issues. It would be good to establish a relationship with
> the vendor, obtain hardware, and other (technical and financial) support, if
> possible.
> 
> Is there any specific hardware now available (generally or in beta) that
> can be obtained by us to take a harder look? A contact at linaro or QCA
> willing discuss options?

There exists some hardware that could be used, but at the moment I have
not ported this code to operate on it.  It is a current effort however,
and I will be glad to keep you in the loop on progress.  There are a
couple of target environments we'd like to support but until last week
the primary goal was inclusion in the upstream tree.

I will follow up with you after the dust settles a little bit with
this patch series, maybe in a week or so.  In the mean time I'll
also find out whether there are any other resources (people and/or
hardware) available.

					-Alex
