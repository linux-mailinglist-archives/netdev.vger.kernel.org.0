Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E280417A857
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCEO6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:58:55 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37964 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgCEO6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:58:55 -0500
Received: by mail-il1-f194.google.com with SMTP id f5so5270477ilq.5
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 06:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4bV4e2J0Fj77NrhTqn4U15G8AA1APxJOoLr6qnKhOMc=;
        b=esoOeJ8vk39jzQbYXfJq1SFqiVch6RalQvjHVWANNM+olC7WkFv8UUMuQ4k+3AeujU
         ldsf+SXtvo2g8fplfXNBTqV+HxFYw6ytavS9Yi7rvCgn997XMPTs3uiEzZjmgelDYMCA
         xNyZd/mKHxBuLL6JVZzGh0lwA3OO4C0t8vi2Pt+RiDN9vgxbT+NiW1IRO5iE9ITrZ2w3
         UP+RFRkwFWKqt51wrEKEBUiHwdgDyL+BIAkI+DrfdBZ+kU6HSCM1xHd8nnrR+rguCUE5
         lW+cVrCGK3+K8UgQ9iuIpsdovS8ZDK3sNetDv3lVs7x9KFBjvTXoLDXZhTOxKkb3wbQR
         PWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4bV4e2J0Fj77NrhTqn4U15G8AA1APxJOoLr6qnKhOMc=;
        b=pK/J4Iaj/ko8kvOvBe4waisAJtV/pIc8d8bMiF2XSXTNHcnuMILfyEXwxpSfx6OM7w
         MbEm+cG+LbRaAPu2DsCWoTDJsH+CVug1B0UxYpW7SfXut0Bg7Aqldh1stAJlZkYUh+Vr
         6GSbxeEUdojHcCMUYA8Qdn+F2ooIodK7B3n2LdbPAetyJtYqXnRoGnq8o4QUcbPwUcmW
         IcmI6uQ4xcy8dJIRUFs1Ea/mpsI94vV4QyUmKcaKsn4ZzfNC6hGwFVY1EtMXUcpoGikx
         GlOIAExRM1Tk1mudwxB07QtuYjWjE+pcAiF7vW+BTiEAJPZTthg/NHUsMYhVRtUPb/Tb
         YU0g==
X-Gm-Message-State: ANhLgQ2cIy+kh1LKaRrGXjLxm0O6/coQtyQGrbTj3QphBECiVlxIPuIG
        ORTB3PjEtltgCHoPRg8il5lcGg==
X-Google-Smtp-Source: ADFU+vtpeY9CxlaepFzd4eHxFzmg0UDavlbEE426APDD8aZtC+Rwtl+OAoe0AHeKrotvehazhLMiPw==
X-Received: by 2002:a92:981b:: with SMTP id l27mr8649435ili.118.1583420334176;
        Thu, 05 Mar 2020 06:58:54 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id p78sm6860932ilk.76.2020.03.05.06.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 06:58:53 -0800 (PST)
Subject: Re: [PATCH 00/17] net: introduce Qualcomm IPA driver (UPDATED)
To:     David Miller <davem@davemloft.net>
Cc:     arnd@arndb.de, bjorn.andersson@linaro.org, agross@kernel.org,
        johannes@sipsolutions.net, dcbw@redhat.com, evgreen@google.com,
        ejcaruso@google.com, syadagir@codeaurora.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        robh+dt@kernel.org, mark.rutland@arm.com, ohad@wizery.com,
        sidgup@codeaurora.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200228224204.17746-1-elder@linaro.org>
 <20200304.141547.1905642444413562833.davem@davemloft.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <d422e872-ed97-76a0-e8d8-457e8932f4ff@linaro.org>
Date:   Thu, 5 Mar 2020 08:58:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304.141547.1905642444413562833.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 4:15 PM, David Miller wrote:
> From: Alex Elder <elder@linaro.org>
> Date: Fri, 28 Feb 2020 16:41:47 -0600
> 
>> This series presents the driver for the Qualcomm IP Accelerator (IPA).
> 
> This doesn't apply cleanly to the net-next tree if that's where you want
> this applied, can you respin?

Yes I will do that today.  Thanks.	-Alex

> 
> Thanks.
> 

