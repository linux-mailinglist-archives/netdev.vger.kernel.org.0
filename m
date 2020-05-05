Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FEA1C4B10
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgEEAao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgEEAan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 20:30:43 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663C2C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 17:30:42 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r4so225377pgg.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 17:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G9m3tUKx0iu5Orqy3hvEfJ7xP503opkqDayoNMwoLvw=;
        b=XGhlM+DRSDKPWGwfo9u86VJEZYIAuWRCDw+l93DqGtDoN5KQT7421R5z8JqgW4rOrH
         iH3pzvbSpqjdyzKfOoS+6PAEhOAm722ncHx3OICQRAlvLstQzaID4q3cDgoPkoeLcqI7
         /5t2f7GVcQJQ0IA/IODnak8RRIMjBCw4thSnSpMj0rJxpLIZL77Lrb+3Zfe9ZYzUohoF
         QF5G5gLvmzLNCb05M7/DYJFPfqPtPkS+a9waiubKq4N+kXub4l7eV8BbljE711PybLuz
         9v3Jo9DLnQxGivF5vUM+3mzKfW2+Gsp3NNKBf+luBHoe9RghZyA7cKX8P+CaCARhbjsL
         kJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G9m3tUKx0iu5Orqy3hvEfJ7xP503opkqDayoNMwoLvw=;
        b=BMsRoplYO2QcIsCE+0BD4EfCrRutrIQ/QKzgO8NgcLsjs6q9eJmVkfS5Q2yx6mrBS8
         LvntKC3ckFW/rrsB7Voq4zVJ26u/YHEqtMr4JrDt2MFWVNeyHfhnsazPaCVNpaW1/Uhq
         D2SxJe0HPBPNeEVRXfz9vIAhsNJiu4McO0DDqikAg9T0X7Kr4echgsO8WknTf6eTo14j
         9GkObEKDTTayBfOFy4P5YIkipklsdV0AcHsUTPDBDsckFFIScJBBCwPCjBBwi+AP+iy/
         I4J/G9EUap1eBgIDT8bpacgP0ydogEHYI0aVZmipPVtWNA1aUBayF6RI4fWAGMpABZRk
         PsmA==
X-Gm-Message-State: AGi0PuYn9zu3jHoFkH469XisCbvj5UVB/d4lD2S3uJHivTjz5ImIESsF
        N9zLV0QkYZp91Ox3ZBas4xM=
X-Google-Smtp-Source: APiQypJNKVdRfksf7bcxUrnXtCxuVFkH9urOpHcADlqPQvAziUo1FylBATbM6L3/TlDVvtoL0G+VzA==
X-Received: by 2002:aa7:9575:: with SMTP id x21mr584174pfq.324.1588638641780;
        Mon, 04 May 2020 17:30:41 -0700 (PDT)
Received: from localhost ([162.211.220.152])
        by smtp.gmail.com with ESMTPSA id 30sm200333pgp.38.2020.05.04.17.30.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 17:30:40 -0700 (PDT)
Date:   Tue, 5 May 2020 08:30:35 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Jonathan Richardson <jonathan.richardson@broadcom.com>
Cc:     davem@davemloft.net, Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, netdev@vger.kernel.org
Subject: Re: bgmac-enet driver broken in 5.7
Message-ID: <20200505003035.GA8437@nuc8i5>
References: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 12:32:55PM -0700, Jonathan Richardson wrote:
> Hi,
> 
> Commit d7a5502b0bb8b (net: broadcom: convert to
> devm_platform_ioremap_resource_byname()) broke the bgmac-enet driver.
> probe fails with -22. idm_base and nicpm_base were optional. Now they
> are mandatory. Our upstream dtb doesn't have them defined. I'm not
> clear on why this change was made. Can it be reverted?
>
Jon, I am so sorry for that, I will submit a cl to reverted it to make
idm_base and nicpm_base as optional. sorry!

BR,
Dejin

> Thanks,
> Jon
