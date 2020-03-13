Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BAD184C07
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCMQIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:08:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53205 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgCMQIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:08:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id 11so10590743wmo.2
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2KI843FDbouHRBd85ruhxzGckfDCz11csC++VWuyIXQ=;
        b=zA96Wejx8fklWOnqpt5kGuSpxGJ8YMGcEW56AmiwP/bwkphcKNfI8VBBQSPwMqcfHy
         dxeS6bebkk1/27gA2F7wyVpEXzd5rAu3JrvkUuCRcaBIzLhOOMsDufFfMtOuVleRBs5D
         zKVAQgRkaTDqSDz3sFFSwFF4hnScmkORSCPATqO1W4Kd5xJTSuzUizi5EAN6xPsBqK/H
         4iXdj0rk5NwVLYH+wuHH6HvR4HmWhXxlpdn/qWnhwycpD2OhRNls17KTX0VAdNID9QrY
         +H4V8kGWe+aR1hIl01vHJHyIgmeVC76ptNaujVrEIrN5jQK8hu60N6h54s/6MfBkWWrW
         htLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2KI843FDbouHRBd85ruhxzGckfDCz11csC++VWuyIXQ=;
        b=Gv922mwl/NiosQKw+mo6t3mJfh+8S43EOOt1e0pgjVZG8aKLVfLYhLGm6xF7dap2aI
         5f02X3OgfeX4BtYb9hI8R5g6eRIvGALeMRphLgDd10afPBRm3ztC0QJCSxUF8kKhqpyq
         sI2YbY1CvOl2DttbNWcUDFFN5EIJsTI2Udl2r8oJXHRELUB0AYIYYZlNVYN49Y+WVlOM
         U1S/GKcyqqNL95wiJT3fNy8rG2D2lxkXuVJSFESKedkAuvh/7bEbuRGrCy8NITZPWOkC
         7ddjnJLLSPnHRKkrWId1ZLTxlo5yzxlyDFKLUb+YWEXtSLPrcsqAdZtlPrTAqZpW0RVL
         5qpw==
X-Gm-Message-State: ANhLgQ0THd7QCOumD0DKF6Beod0YeGSMxE5/XfkeDI9Pt+N5rwO2Fiv3
        ruudNJJjEJpWWH+Jwokm9fCYgg==
X-Google-Smtp-Source: ADFU+vvlCjNjoEEUZz8V5srFZ0chQzqh7Vpq273OjvnATWGHy8RUsOww1g8LZl8azAqSnS9pS++xlQ==
X-Received: by 2002:a05:600c:258c:: with SMTP id 12mr12021308wmh.140.1584115712962;
        Fri, 13 Mar 2020 09:08:32 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (81.243-247-81.adsl-dyn.isp.belgacom.be. [81.247.243.81])
        by smtp.gmail.com with ESMTPSA id r9sm10463928wma.47.2020.03.13.09.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 09:08:32 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] mptcp: drop unneeded checks
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <cover.1584114674.git.pabeni@redhat.com>
 <cd82fc7a869af40debec550fb1270ff8a159296e.1584114674.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <a5d51065-c20c-3598-aebe-6ea220175615@tessares.net>
Date:   Fri, 13 Mar 2020 17:08:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cd82fc7a869af40debec550fb1270ff8a159296e.1584114674.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2020 16:52, Paolo Abeni wrote:
> After the previous patch subflow->conn is always != NULL and
> is never changed. We can drop a bunch of now unneeded checks.
> 
> v1 -> v2:
>   - rebased on top of commit 2398e3991bda ("mptcp: always
>     include dack if possible.")

LGTM, Thanks Paolo!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
