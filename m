Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4910064
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 21:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfD3Tlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 15:41:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41287 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfD3Tlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 15:41:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id f6so7311281pgs.8
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 12:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JYyOSRB+35GoOgzVAVZ1PxtBkzoE2H9cHm+FWy1I/SM=;
        b=M6bSwWrI4yoeRTL0xe1v6f6uBlJtVvOm89tJlShrxlGPRXWJKOd4ILpuUFrC5IJN0x
         rCW5mpsovd6zGbJD+tc0wNCpAln4grTOUPQfMDiuLzMs3+wmMtcyiz+nGQ9DMDYQWxIV
         6jog4DHfG3QNW15ZAWDzVuPd8J/JJ3x0XaIU1LsFzdWPIXzyevkdvmYm3I6aE5Wvkbey
         DQwdZ/EdB6Xq9LnOf0lQqObdSpA1MqohKfRfq4UByU3oQ91cAyIHhaVVDb5khNfmasGJ
         WE6+bH1oKzKAUjRVh5ApIpeq2BVL8T+AAKezxqK6gU2fbl2pjOPuWHqNdLwZnL82u7CJ
         7agQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JYyOSRB+35GoOgzVAVZ1PxtBkzoE2H9cHm+FWy1I/SM=;
        b=c+iiX+CHb2tjjITPozxcUY8lBgZg/mEg6s0D9mSG3zN0zquVhYJCdY2Abqp2JgaORX
         lHvby3FrL+7hwFNbKdRVZXqWn9UbsvtAT7+HgCSuxxWuGkEBiBrdh8O0nQ4U6qT6yRtK
         9ZaxiZBTIrhviBBkRtg9/sAPWVeieZOKQQnwCpcJU+uJjujskirnMiW+uibQs1yMquz0
         VgkbchPfavpJDhs3GAftvzsr7BhS71NAKMjz3iQqYIpUCvouNwaJ5+YJ83+s7cG9HMnw
         RAykmOWUU9zXQPqV6dJpyGylq629g+0ta0htI87nwQSgxD+mLESK6PJPEsZr/98RjCvZ
         ocyQ==
X-Gm-Message-State: APjAAAUEh4fLOyUPnFNyXcL0PQJ8ZoMyk0DvSlqXNjqdEmUhM6Fz1AKA
        /6yVIveQe2vYICe9mmxKVXlFkj8H
X-Google-Smtp-Source: APXvYqwMM5nn+9cF0eiXcsf5AEwm+glPy14T+496NvXeyIWmLn8ukYZ1AiuS1ASNxJXUXeUii9dDig==
X-Received: by 2002:a63:6cc7:: with SMTP id h190mr67373095pgc.350.1556653301492;
        Tue, 30 Apr 2019 12:41:41 -0700 (PDT)
Received: from [172.27.227.169] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id i135sm58850835pgd.41.2019.04.30.12.41.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 12:41:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ss: add option to print socket information
 on one line
To:     Josh Hunt <johunt@akamai.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <1556227308-16057-1-git-send-email-johunt@akamai.com>
 <7f3e7f62-200c-fba3-96b1-f0682e763560@gmail.com>
 <f1a1cd3b-8b85-3296-edd0-8106b7e28010@akamai.com>
 <1f1ca56d-bfd7-7fc4-1fed-cff2cc69c6f7@akamai.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4ff0fbb5-9f32-440f-8eac-6f05b405b934@gmail.com>
Date:   Tue, 30 Apr 2019 13:41:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1f1ca56d-bfd7-7fc4-1fed-cff2cc69c6f7@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 12:55 PM, Josh Hunt wrote:
> Actually, David can you clarify what you meant by "use 'oneline' as the
> long option without the '-'."?

for your patch:
1,$s/one-line/oneline/

ip has -oneline which is most likely used as 'ip -o'. having ss with
--one-line vs --oneline is at least consistent to the level it can be.
