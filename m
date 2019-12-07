Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB64115EE9
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 23:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfLGWSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 17:18:09 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47026 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLGWSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 17:18:09 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so11715717wrl.13
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 14:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E8evvGNJu5TMg9SpPCOLuK9LLILsLyXULeGPY4TIcJI=;
        b=jJOTTt/6DtgBXUK4zhbHwcWAwK+diOTzXZI6sPas6I4RDx6uDp+1QGl9QTh9oA9DR8
         7jyYXJobMWSgq4ewz0ulXZJk/DXIfD+StfGTGGI/h/1DLBVZ81DsXlvrWpOxdUYidGMR
         m1suixeFUjniOs3F4AqPcpVYkTaLDtZjUDJcxCU97DpP+zUgx6gwR+3oc4Gf9hfyCEFw
         6LN8M8uhJTndk5reu7qaEOat+lkAAKQm16QXRqbYt7hJjp4HNwHZDh9FgdL57/g6jTyg
         6MXeV86PlFha8fs6D1ELcVyg7PaBeihHK9b8chcdDWHc0x0dctWuesMy7iTViXfGWWFY
         YNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E8evvGNJu5TMg9SpPCOLuK9LLILsLyXULeGPY4TIcJI=;
        b=pI5X4TGyPH7H8rEQ7sDHKF1w/XTSFcZrBMfT1mwTTYFRWkqu68b8jtXTenEs6YnyD3
         gCx+p+47Cc3WhQ+YzrhwXcJRUtgRCjMYcXi1kxxk9c/FDUVgR0lZD1veEMRMbKh4d4ys
         NKxt3PrnA+owlKYM32ylXDKYrpR+m8RqJ80Sv4zId7motVv2S0J0bWUe5twD7vLifbCi
         AQMibyJIspvn/4mrXWL1g7PTeb50VPzU+fAmcMphImIjMkWHvoNZxu4U7AVVhAqyD0PV
         aO2TeA/b93l10j9cLH/UPhf9MZuORheuxQwPjsQIPWmG6rQEe7aJrcsNL/jy9sThdN54
         jmIQ==
X-Gm-Message-State: APjAAAUs3dPsAB6OL7SB78s9VKqiDA2qgeq+duQqo9w+/y/IY3tIMZhW
        lYD0kqhNxiAlW+QJe8GwYUiCvSYP
X-Google-Smtp-Source: APXvYqy40WQF6sxI5c4mMEOsga4+RPVakfpunrpsWu+skhs/k2T7j2sVjFDrP3Mwg4b45moiFh3BHA==
X-Received: by 2002:a5d:6a02:: with SMTP id m2mr21785269wru.52.1575757086980;
        Sat, 07 Dec 2019 14:18:06 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:4590:2172:4cf5:2ac? (p200300EA8F4A6300459021724CF502AC.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:4590:2172:4cf5:2ac])
        by smtp.googlemail.com with ESMTPSA id t1sm8595603wma.43.2019.12.07.14.18.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 14:18:06 -0800 (PST)
Subject: Re: [PATCH net] r8169: fix rtl_hw_jumbo_disable for RTL8168evl
To:     David Miller <davem@davemloft.net>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
References: <8aa55fa1-5ba6-2f65-e651-463fe3bed303@gmail.com>
 <20191207.120131.1111830958409064329.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a841f322-22dc-5eb3-d406-788a3a72c803@gmail.com>
Date:   Sat, 7 Dec 2019 22:18:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191207.120131.1111830958409064329.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.12.2019 21:01, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Fri, 6 Dec 2019 22:55:00 +0100
> 
>> Fixes: c07fd3caadc3 ("r8169: fix jumbo configuration for RTL8168evl")
> 
> [davem@localhost net]$ git describe c07fd3caadc3
> fatal: Not a valid object name c07fd3caadc3
> [davem@localhost net]$
> 
My bad, this refers to the commit in 5.4 tree. I'll resubmit.
