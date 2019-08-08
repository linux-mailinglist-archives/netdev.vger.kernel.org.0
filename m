Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108A285A55
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 08:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbfHHGNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 02:13:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41695 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730694AbfHHGNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 02:13:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so90416278wrm.8
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 23:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0U2RwunCYEVlRhtsm4EPB+lmBDkGG7aWR1qQXLEQVrk=;
        b=erxg5xNsyfhA2xDqm0P2gJ6NuTY/vt1TqjfrblZ3v04+kOdKsti7WISuBEK9lBE0eA
         fL7ChaS76ZKYacJGx1098q6LQVkl3J+L5J2nSyVEYqDZZvol3cyjIvq1mjkgGr0+DeFl
         TMvEfyOgbMUaTc1Eslk0LpM0qqQhX3KOT/r4OIqRx5thQnCzi5pzURWrV71y8e1jS2l5
         s/5C8s+8gR7Kh/mw0nqNa9V/RhqnvbNi4h8HDyLTTTQmsjbZ4vRtO65pbhVa7He/oyES
         lObwEft+u0KziL3c0dT19+YvQHepHErteaZNWlXi/d/t6lCfJbx9huTcacSUG0Sh0YGl
         +xbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0U2RwunCYEVlRhtsm4EPB+lmBDkGG7aWR1qQXLEQVrk=;
        b=Y5a8pneoN8gME84QlhfugQS6pnz9Jy+owjiC3o85nKINyyNef7UvJWjLgryVP/DEvT
         IBb9LwMnGNhoBrCW1GlPE+fSn0H8N/g7fYvDDlPP17a4JS6mcyeAq4Votu942I9w/qH+
         nhuzJxOhJQ05qvvLM/nwAaFfiWs1gnduIJkQbMMM3WeK/MANqZCSImlvJ3wy3IRb8Aw/
         x/03B3+VKlepb2L2BC/X7GWZJwPyT1b2IxAO7pK6Vwv6DsOmI0n70VRzOM5naf8YhvoB
         yTbPs6Du4EmcvSaSWRp+ic96oFKab6j/2EEdjJnNCrn05F5acSMcsaCcXA7zRut2Qvyu
         z0jw==
X-Gm-Message-State: APjAAAUmP7gtvqgT6OH2RfwFRZcCDRxh7LBQPJESD9VRtSBQ41YHB92B
        yvBxClxQAoSVS9lVY2DtMI0=
X-Google-Smtp-Source: APXvYqzjqX8qauoAllUPCBjITBTuOWGZ60dCLZSEDLMgufwDwDGeSNrAc9ehES5q84oprilXmHIqbQ==
X-Received: by 2002:adf:d081:: with SMTP id y1mr15463593wrh.34.1565244794098;
        Wed, 07 Aug 2019 23:13:14 -0700 (PDT)
Received: from [192.168.8.147] (72.163.185.81.rev.sfr.net. [81.185.163.72])
        by smtp.gmail.com with ESMTPSA id 4sm217875253wro.78.2019.08.07.23.13.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 23:13:13 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] tcp: Update TCP_BASE_MSS comment
To:     Josh Hunt <johunt@akamai.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, ncardwell@google.com
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
 <1565221950-1376-2-git-send-email-johunt@akamai.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c1c2febd-742d-4e13-af9f-a7d7ec936ed9@gmail.com>
Date:   Thu, 8 Aug 2019 08:13:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1565221950-1376-2-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/19 1:52 AM, Josh Hunt wrote:
> TCP_BASE_MSS is used as the default initial MSS value when MTU probing is
> enabled. Update the comment to reflect this.
> 
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---

Signed-off-by: Eric Dumazet <edumazet@google.com>

