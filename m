Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F18FC8E0D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfJBQOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:14:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45026 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfJBQOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:14:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so10600832pfn.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=eeyTOg17q9KxMpdnKIdB7cChcxt684Nc0Z/pTXOp8y8=;
        b=EP1pH7wpiE0TYKvhUm2wWyzT1PRmnrtJW2S9yGvLz+UQS5H6/InXwE+x7vcQn0YkA8
         FvYrIpIaayfSv4Ts2FZYpj3clWi/NGLG/G3R7XP1QXkQqsFA+p03EIgoGlgNePuVOKte
         EV2xbhJPg+0sbcZIjH2QWZyQcxkXcsqBDBFBGsAG+au4XuTyaRh7n3OKaPHzKopsBy0D
         UKEmC1UUp5TnLJB/BzgH+VR7a60BkAmOYCpo8QG8Zz0WcDX/gt+ScP5hZv0bfiIbfid5
         VtIAGaDfjpZDJsmbs5y6TakZJvKeAeAbclrWPjG2I6CjzEY6C4bLgws3vjG9QhFFf/wO
         LjJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eeyTOg17q9KxMpdnKIdB7cChcxt684Nc0Z/pTXOp8y8=;
        b=TyZynllKCMSpeagxfbLnLQdEZnpNQ/tReW7Uy2Gs91lZgtcc7qtVaMZdGSyhKCFzei
         VF30dnqR3tbEWbv9dz1088FryrfQX9ZioV9vXVCNNbVEM9D/T8OKP8xD8umpj2WD+0Ud
         7y620nrh/w88h+oXle9kijBculeAOASUUfW7zS0BcovnF4IQDpzDGBz6vPA0Aj3gzuKB
         j04FozriyhUfzeWm+LPsXlT4t+rbs4r5lxqi81f7cNH0gF5v3ZdIvlsIiNdBzT3b1DSf
         S0b0VX3OLiBJxvvli4dvyAdEkVOc6+bNd4l8OgMPjGVv4vpE8LuvcqKyS/zVJ0Y4nmLY
         W16w==
X-Gm-Message-State: APjAAAXjm8M3/8taTAuIDqQ936akDoXFeC9q/mWJ5w9rU1mnsDdYzJDT
        1nz2DfRT/ywQyEVYCIdDMJB/mL6GJGI6fQ==
X-Google-Smtp-Source: APXvYqxrTJaVirNXUIMjjQQYz+vd4XBrvrCFGiFDXmev6sjlsTLcobvsJWUnNNcWVcQJlboCNdrkOA==
X-Received: by 2002:a62:e817:: with SMTP id c23mr5436656pfi.230.1570032873121;
        Wed, 02 Oct 2019 09:14:33 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id z25sm18095592pfn.7.2019.10.02.09.14.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 09:14:32 -0700 (PDT)
Subject: Re: [PATCH] Documentation: networking: device drivers: Remove stray
 asterisks
To:     =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?= <j.neuschaefer@gmx.net>,
        linux-doc@vger.kernel.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Pensando Drivers <drivers@pensando.io>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191002150956.16234-1-j.neuschaefer@gmx.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <1fd5d5df-30ea-2545-daf6-575473879cd6@pensando.io>
Date:   Wed, 2 Oct 2019 09:14:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002150956.16234-1-j.neuschaefer@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 8:09 AM, Jonathan Neuschäfer wrote:
> These asterisks were once references to a line that said:
>    "* Other names and brands may be claimed as the property of others."
> But now, they serve no purpose; they can only irritate the reader.
>
[...]
> Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")

Acked-by: Shannon Nelson <snelson@pensando.io>


