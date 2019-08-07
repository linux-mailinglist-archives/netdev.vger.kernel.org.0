Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8418536D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbfHGTIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:08:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34149 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388939AbfHGTIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:08:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so42212453plt.1
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3aapQLZrct60SM6F0lEBFwVqxSIlY9TT9t7CIPPjZqA=;
        b=N/4z1ggvakcVOy1u9YKRPB+Ax3Ey1afwRsSXwMimWm0fbisZEjogbj7XBY2zlB9PiD
         Sd2ln192oml2QLxPZiq6QpmSp0Jgr6alHMwZX9EkEcEVsGYVMh5IcBpunjh/GJUc3IEB
         H919Pa8W/gZ+U6gSvw8lCFP6REXplhm/QrQ77ruVXPzkcVCEkHvNKGz0cxbCjvr+fCf5
         9BwPMnkbQ6V07JJNbs+hvlTHRe/lP2wCPqjhvxGemcMXyWJDvuHtUTX9x3njcvT8kmmT
         LIiUqIDk13S9xB2I7l9XvsB4xfRG9tWx5+S9+Z8ThwT9jseHH2ronIiL72iI+jeiQ5GE
         3JEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3aapQLZrct60SM6F0lEBFwVqxSIlY9TT9t7CIPPjZqA=;
        b=SZtV+7b29az5mY9XqswPegBngvqOdhmX9fdYGdJlbsorDEtPKmoja/01l8OVTlX7NN
         pgi1W1YtgN7uwUG065bXqKTqXsV2cKMZ1XX62x91Qd8lFESPDHwNZ29jdaqvLwO6+Gud
         OR539fVawNLL8T3DOGeSfvI5RC6xUPlP8j7GAU296FpTDMlZp8kmxOM2ACt4kIXEb8OD
         BYczoFMYPMbeHOKwYdJx6Vqn8rkocCHFc7egxeEBrg59TMEh3Y77ABl/cdZz0nJz+iy9
         /NP1q0w34Ugo4PJTTmOJdOLHFzJkkCcETlh8RkuLaGMdnnrmZIR4m5CVCe9vzWaIDUHZ
         BGvw==
X-Gm-Message-State: APjAAAVuq3HZYka0ZaaY5OT5Gws6PvLc/IwAp8qfEMc/5h+xln1knHHe
        Dba2jg3Mf+xjiXXmNzFY0pY=
X-Google-Smtp-Source: APXvYqxUuL7XF6Qjaw3GYO/tUXiK/PmcIAZV78dd/Yj3dRuz2l0/4GEgu4TO5eEUXmiHX0cBpfM4nQ==
X-Received: by 2002:a17:90a:b115:: with SMTP id z21mr1375743pjq.64.1565204886034;
        Wed, 07 Aug 2019 12:08:06 -0700 (PDT)
Received: from [172.27.227.247] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id n28sm11901241pgd.64.2019.08.07.12.08.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:08:05 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] ip tunnel: add json output
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <a7a161117f3a68e5a0cea008a8ca7e80b42bf2fa.1564766777.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <24481a26-54a9-b3c7-14e0-16e1325e9a82@gmail.com>
Date:   Wed, 7 Aug 2019 13:08:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <a7a161117f3a68e5a0cea008a8ca7e80b42bf2fa.1564766777.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 11:38 AM, Andrea Claudi wrote:
> Add json support on iptunnel and ip6tunnel.
> The plain text output format should remain the same.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
> Changes since v1:
>  * Use print_color_* for ifname and ip addresses;
>  * Use print_null() instead of print_bool() where appropriate;
>  * Reduce indentation level on tnl_print_gre_flags()
> ---
>  ip/ip6tunnel.c | 66 ++++++++++++++++++++++++---------------
>  ip/iptunnel.c  | 84 ++++++++++++++++++++++++++++++++------------------
>  ip/tunnel.c    | 37 +++++++++++++++++-----
>  3 files changed, 125 insertions(+), 62 deletions(-)
> 

applied to iproute2-next. Thanks


