Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA1192EA6
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCYQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:49:54 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36889 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgCYQty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:49:54 -0400
Received: by mail-qk1-f195.google.com with SMTP id x3so3283477qki.4
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0A+2lYiNIEXZRek/zk2Xml63CdHnnUNXYwFqnqSF2hQ=;
        b=BtfzNoYPMEQVjr6dFUPabUHYeb/U/V3GGuZAIlkfu98DXhzMSuBJ/ChHEtuSvNP2yj
         zSY1kTkcGXtYDBh5UusUlF6wT/BOfymI3892fLZ5hZTGOarPBEU4DWzh0iIKSIiLPULf
         g4vJUNslX/buPvcVk+x0fegGVgUoO0fVbGOtcV0sYG8TvFSjSFuw4l6sLr8NPD6Ktx9+
         YE+uWqhRo8GLH2FoaFB2cpHIFpkVO8X2uJT+tukyEDmZQYx88bmY8DuX2U46bQEU3yXW
         Z1tCCdzDzcYAhbpSE39x0/e0kUIGlTfOCKzVye7K5jkski+dYo0+ChEmmlkNuSRBpjrA
         1RgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0A+2lYiNIEXZRek/zk2Xml63CdHnnUNXYwFqnqSF2hQ=;
        b=umMSBBjGLspLeUxLCUiqb0TNEYQZ8DK+BFwL3z1/pYDtLA+E7iwvmexqYIk9cxdHZE
         +Tz3mkXkybqj50snpMrqWKMn10sjozeCQjbpPAFC31TgD9FPHL6Uy0UtY37HztR6xm1B
         BINI0WpkmyILtPJgpEMdTwE8oGRM3v5Wt0kMX32hmuKXvzxd0rPJ1PPaYIbkvBy49bA2
         oYhNjBMY8xHNznizoOhZPCgjYCYCDG/k0O/uiPwVsXIjybENQNX8YA4o93GjaeiCziFG
         Y++TPsfbEO8PVzvkms2vvmRgIJ5PX8VfA5VhNvaBI2nzvj7ToP5XpilR/1SmjoGNdlVQ
         HNjA==
X-Gm-Message-State: ANhLgQ0m7B019IPnjr7owlrFYZWmUF6yKi1iMJNGWxPbK4IMMwU94N6X
        U6b48MMgbVO8YeSnlx0T8ms=
X-Google-Smtp-Source: ADFU+vvby/ZRu/fNzZJotREkGNB+kRXenA7zqla3A6RTTLMUfv4R9VavoneKSEyAnHatkDcFK4lIrA==
X-Received: by 2002:a37:cc1:: with SMTP id 184mr3907402qkm.430.1585154993384;
        Wed, 25 Mar 2020 09:49:53 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5593:7720:faa1:dac9? ([2601:282:803:7700:5593:7720:faa1:dac9])
        by smtp.googlemail.com with ESMTPSA id d24sm16031155qkl.8.2020.03.25.09.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 09:49:52 -0700 (PDT)
Subject: Re: [PATCH net] selftests/net: add missing tests to Makefile
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <20200325080701.14940-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bc75ccde-a1f3-7631-9636-ca387561a4cc@gmail.com>
Date:   Wed, 25 Mar 2020 10:49:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325080701.14940-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 2:07 AM, Hangbin Liu wrote:
> Find some tests are missed in Makefile by running:
> for file in $(ls *.sh); do grep -q $file Makefile || echo $file; done
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


