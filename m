Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0353742DBF4
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhJNOop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhJNOoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:44:44 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801A3C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:42:39 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id y11so5896342qtn.13
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/yjEznXe8PGmI25I2l8yi3gHnvsfZLZpG8yYDPxzg30=;
        b=ZK82Rea8GAm5DZNisT1C9eCp9uinMsoXxUsr84Wl1guunYJA1kdqbGm0WATuI/H7fl
         3nrm7OFGe+K7/IzH32w/6+3yZ+VuTYqkv25ydI9Dy6LDPXD5kymNrkK2RiWti4DcVDp7
         0dsv/ViHwVZqzHcY7lBGX6lHD7W1EE2JLZKUgoYyOCThE5oBJ4Di41ewMI/SYp10dwFD
         zDiQgpIM+PKy5G75O5Z5e5qCDwCUv7aQXnWH0SZdb2cxS3qGA+Q2+iI0//U0EXKhojq9
         sKZaeESeH7vUch9JT6Iy7Uz++JPNYEj1U86Joi3v5W2xOj7IFv8HmBEQF5MhumvQ7XfP
         mJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/yjEznXe8PGmI25I2l8yi3gHnvsfZLZpG8yYDPxzg30=;
        b=hEAuz/Xy1PH/+N/3q7Y6EL93xFBIQyxa85LDsyGdLVuLGCRmq1ZIv+jOlTYbYkWnEJ
         Bf1NcPT9ExUGqkJ9h676cV1l03mNrrAZW6Jl6VWMImvlHlrOk4cWIHxwkt48+cXWNjLF
         Splq24b622uJYunX7a7eDsEtMxkXD/HA2ajGdLxU8CrDhkpio414TQnxE30woN16zHyk
         DQ6dIM8zWwa7Tofy5voVqkxVpNeOEkBHRRFiMQA3Xe1aGo6I559/OOB+heBBWONafcYe
         G3fZ9mAG83UQNgOm0OkfHRfMTltya2tpq6CDx//N9Zj3kOFogJfSLZhyFBn9BJKnP/tj
         VPOg==
X-Gm-Message-State: AOAM530W816Tv46ISqyKxI+3fz8fmssrtdbzh4fXOOgZKl8FhJK/A0cs
        JmvTEitRE5pROydlDMZfcg==
X-Google-Smtp-Source: ABdhPJyQicuO9BMgJP2DmZKCXztmZylPM9J20/1lVvMA7JnX45LIvG3/NliZr7Kq1q1LMzQAS/r1wQ==
X-Received: by 2002:a05:622a:13:: with SMTP id x19mr7033327qtw.83.1634222558740;
        Thu, 14 Oct 2021 07:42:38 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id i13sm1425926qtp.87.2021.10.14.07.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:42:38 -0700 (PDT)
Date:   Thu, 14 Oct 2021 10:42:31 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: ip_list_rcv() question
Message-ID: <20211014144231.GA11651@ICIPI.localdomain>
References: <20211007121451.GA27153@EXT-6P2T573.localdomain>
 <4dddfda5-1c03-6386-e204-e21df07aabd1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dddfda5-1c03-6386-e204-e21df07aabd1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 05:17:51PM +0100, Edward Cree wrote:
> On 07/10/2021 13:14, Stephen Suryaputra wrote:
> > Under what condition that ip_list_rcv() would restart the sublist, i.e.
> > that the skb in the list is having different skb->dev?
> 
> IIRC, something earlier in the call chain (possibly
>  __netif_receive_skb_core()?) can change skb->dev to something other
>  than the device that originally received the packet (orig_dev).  I
>  think it's if the packet gets handled/transformed by a software
>  netdevice (maybe a VLAN device?).
> But really when I wrote ip_list_rcv() I just worked on the basis
>  that "I don't know it can't change, so I shall assume it can".

I see now that vlan_do_receive() changes the skb->dev. It didn't occur
to me because __netif_receive_skb_list_core() has a similar logic for
dispatching sublists. But still the skb->dev could be different that
orig_dev.

Thanks.
