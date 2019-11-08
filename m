Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59041F4AF0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391989AbfKHMMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:12:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33828 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388220AbfKHMMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 07:12:36 -0500
Received: by mail-wm1-f68.google.com with SMTP id v3so7216932wmh.1
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 04:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vi0FXEb1SaKZF+1W08jxMvHKOZ5OFQySHO0NRC440W8=;
        b=k63tbg3ComKTwLI7+A1lutM9sDSJqb95sZk2Bbq4O05Sg5yWeq5zkkNHdIw6xvDmrC
         euJGRWxMCSlcwjvNTfZ82ueGzCQiYa/6POan1a/f9HsxbcNhsse+bqBFXUzBDt8Xnibi
         qGce4fdYovXckgOKtMI9rFnE4e1ZP6pR9xvGLIIcsHGQvaXCpYSz1tq4MSGpnsJo2XFu
         B5PAbUZ/RW2h0cwPeCDqssLxNgKzGiFEv8CikCvCb+NBCLtjIghXvVI7ZSI2Ux13+XH9
         iygblYqwJLz0u3VZyjVQI8qDa7ftROqQ/SROAdW6SHeXdGYvixBnp4LQC7k5hfdEBohT
         RqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vi0FXEb1SaKZF+1W08jxMvHKOZ5OFQySHO0NRC440W8=;
        b=X+FUWsJEjsqxvA8/ijHy5Qxjfce4krGAaS/hQ1I1qcz5UTmGHMCI3ZV0rR6Zi+UWbT
         tz3Up/nOVBAmIxbJ9KCdj+3Ox8zaQdd7DFLuSQu76GrCJm/nntAIA7FDF27qOXoX9hUl
         3x//1vDu1EmTPitvpLt7ZUJc1FM7LECKjArHN4tJzi4JfjYEeSR3oA0bD1qOAP/4f51e
         ksGd7D35phwsllA+5OnHLLiyjWDpJxRzQM90tzVrE0Hx6a/8BW92XyDpUTSmqvZrh+0M
         yDByHEt5cGGf64hBpo3gFNHB/sa8OK4utZNcx6hQYO6456dzP1TGLHp60gZRMx1Pk19V
         tKjA==
X-Gm-Message-State: APjAAAW25ut5Z9ftHyW1GiZeaQbBRi4zBN1P3NRjG340DaYJCO1ukEGc
        SVE2evur0c+0JF1hUidgvYKK0w==
X-Google-Smtp-Source: APXvYqyaVvcyf53tsacNRyq5/ftg7f45Rs1oRCuUUTHNz0pnl3bHqejbD4wPXM08nTvMBhQQvwJoOw==
X-Received: by 2002:a05:600c:2945:: with SMTP id n5mr8532196wmd.80.1573215154142;
        Fri, 08 Nov 2019 04:12:34 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id p10sm6917186wmi.44.2019.11.08.04.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 04:12:33 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:12:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108121233.GJ6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107153234.0d735c1f@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:
>On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:
>> Mellanox sub function capability allows users to create several hundreds
>> of networking and/or rdma devices without depending on PCI SR-IOV support.
>
>You call the new port type "sub function" but the devlink port flavour
>is mdev.
>
>As I'm sure you remember you nacked my patches exposing NFP's PCI 
>sub functions which are just regions of the BAR without any mdev
>capability. Am I in the clear to repost those now? Jiri?

Well question is, if it makes sense to have SFs without having them as
mdev? I mean, we discussed the modelling thoroughtly and eventually we
realized that in order to model this correctly, we need SFs on "a bus".
Originally we were thinking about custom bus, but mdev is already there
to handle this.

Our SFs are also just regions of the BAR, same thing as you have.

Can't you do the same for nfp SFs?
Then the "mdev" flavour is enough for all.


>
>> Overview:
>> ---------
>> Mellanox ConnectX sub functions are exposed to user as a mediated
>> device (mdev) [2] as discussed in RFC [3] and further during
>> netdevconf0x13 at [4].
>> 
>> mlx5 mediated device (mdev) enables users to create multiple netdevices
>> and/or RDMA devices from single PCI function.
>> 
>> Each mdev maps to a mlx5 sub function.
>> mlx5 sub function is similar to PCI VF. However it doesn't have its own
>> PCI function and MSI-X vectors.
>> 
>> mlx5 mdevs share common PCI resources such as PCI BAR region,
>> MSI-X interrupts.
>> 
>> Each mdev has its own window in the PCI BAR region, which is
>> accessible only to that mdev and applications using it.
>> 
>> Each mlx5 sub function has its own resource namespace for RDMA resources.
>> 
>> mdevs are supported when eswitch mode of the devlink instance
>> is in switchdev mode described in devlink documentation [5].
>
>So presumably the mdevs don't spawn their own devlink instance today,
>but once mapped via VIRTIO to a VM they will create one?

I don't think it is needed for anything. Maybe one day if there is a
need to create devlink instance for VF or SF, we can add it. But
currently, I don't see the need.


>
>It could be useful to specify.
>
>> Network side:
>> - By default the netdevice and the rdma device of mlx5 mdev cannot send or
>> receive any packets over the network or to any other mlx5 mdev.
>
>Does this mean the frames don't fall back to the repr by default?

That would be the sane default. If I up the representor, I should see
packets coming in from SF/VF and I should be able to send packets back.
