Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B287D3376
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 23:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfJJVcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 17:32:48 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37669 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 17:32:48 -0400
Received: by mail-io1-f67.google.com with SMTP id b19so17096782iob.4
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 14:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oUufLVTB9SD7TuDGc+AbJ8uyzKCYD9UEJEiiV+GS3+k=;
        b=Fb9YmF7KnpOSqfCKaLGMxo57MT/7mHZ8c9wG/FgCfSGO/7+PLdvWenCkOI7TtLIVyd
         A+r54VGGEqsTQKw4etVdAD5+mis5xkvp4ac6IJ5Cy/EjPL1A9j1busvqeTEItgVrMvTH
         kvK3ddmhjR/pLo5nVJy7JVPge+4UgREpAHWx8/6GcPZWXKNBtsS8HIw4jg2mVTo5IU+q
         0wAi9lNfp69v/Iy1t8DT1YJTCdMB0STwKxX0DJgtPsSwkMsl4OVtSJ5qn/Cg6sFWaZgj
         ECKfDvsN+NWtTgGCmRYBi6EEwe+ecfYvhWq/esPBp/tS0mZXf9E3n9cbN2T7VO9yu0OM
         Y3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oUufLVTB9SD7TuDGc+AbJ8uyzKCYD9UEJEiiV+GS3+k=;
        b=SzrQHCLJ58UcDUPepzxApqccoL+T/7cBxnvqBeovzW+/irlBGfDAAYSIbRN7FTC890
         5XDviStoej/OhozhrH6FOMYUemJGo88glEis6a5IjZy6YHylILCmPJLHSL5PCBiZm3qT
         xSKV7NjRxscM/axObOqeHsAJC82C4rwceUz551MAtrURE0yq3NSPpWLdzZsVBXZ4D/6y
         +91RcKYke3cb/7okYQidMxAIKIAo8XcGZhRo8Fbl0HxvhGnqMHaUpQmDDsdZYnaS2S+B
         goKR1xcL7WZgK5JlGYnn9UC5Fsz5rJYUkiDoG7toxqSRfZFBp/cMq48/52E/CiyLJHB+
         yojQ==
X-Gm-Message-State: APjAAAV6gxqYeglYcAOc/8For9FawMZ/XDnN5OARm20uxjGf4sGFt8HK
        PU6QT9mGTM0TBeVMJ5wnxwSj5JHeWYOJQ/wkf/0=
X-Google-Smtp-Source: APXvYqxS/off1J27p3z8cmOI35cBL8PCFyDRUcUuAUNeYGtDqjsgZcHziW5a+r+Ut51Oz95XmsG3+yv2CkhmQyk2Qyk=
X-Received: by 2002:a02:bb0c:: with SMTP id y12mr1407593jan.96.1570743165761;
 Thu, 10 Oct 2019 14:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <1570658777-13459-1-git-send-email-johunt@akamai.com>
 <CAKgT0UdBPYRnwAuOGhCBAJSRhdHcnw28Tznr0GPAtqe-JWFjTQ@mail.gmail.com> <cd8ac880-61fe-b064-6271-993e8c6eee65@akamai.com>
In-Reply-To: <cd8ac880-61fe-b064-6271-993e8c6eee65@akamai.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 10 Oct 2019 14:32:34 -0700
Message-ID: <CAKgT0UfXgzur2TGv1dNw0PQXAP0C=bNoJY6gnthASeQrHr66AA@mail.gmail.com>
Subject: Re: [PATCH 0/3] igb, ixgbe, i40e UDP segmentation offload support
To:     Josh Hunt <johunt@akamai.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 2:17 PM Josh Hunt <johunt@akamai.com> wrote:
>
> On 10/9/19 3:44 PM, Alexander Duyck wrote:
> > On Wed, Oct 9, 2019 at 3:08 PM Josh Hunt <johunt@akamai.com> wrote:
> >>
> >> Alexander Duyck posted a series in 2018 proposing adding UDP segmentation
> >> offload support to ixgbe and ixgbevf, but those patches were never
> >> accepted:
> >>
> >> https://lore.kernel.org/netdev/20180504003556.4769.11407.stgit@localhost.localdomain/
> >>
> >> This series is a repost of his ixgbe patch along with a similar
> >> change to the igb and i40e drivers. Testing using the udpgso_bench_tx
> >> benchmark shows a noticeable performance improvement with these changes
> >> applied.
> >>
> >> All #s below were run with:
> >> udpgso_bench_tx -C 1 -4 -D 172.25.43.133 -z -l 30 -u -S 0 -s $pkt_size
> >>
> >> igb::
> >>
> >> SW GSO (ethtool -K eth0 tx-udp-segmentation off):
> >> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
> >> ========================================================================
> >> 1472            120143.64       113     81263   81263   83.55   1.35
> >> 2944            120160.09       114     40638   40638   62.88   1.81
> >> 5888            120160.64       114     20319   20319   43.59   2.61
> >> 11776           120160.76       114     10160   10160   37.52   3.03
> >> 23552           120159.25       114     5080    5080    34.75   3.28
> >> 47104           120160.55       114     2540    2540    32.83   3.47
> >> 61824           120160.56       114     1935    1935    32.09   3.55
> >>
> >> HW GSO offload (ethtool -K eth0 tx-udp-segmentation on):
> >> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
> >> ========================================================================
> >> 1472            120144.65       113     81264   81264   83.03   1.36
> >> 2944            120161.56       114     40638   40638   41      2.78
> >> 5888            120160.23       114     20319   20319   23.76   4.79
> >> 11776           120161.16       114     10160   10160   15.82   7.20
> >> 23552           120156.45       114     5079    5079    12.8    8.90
> >> 47104           120159.33       114     2540    2540    8.82    12.92
> >> 61824           120158.43       114     1935    1935    8.24    13.83
> >>
> >> ixgbe::
> >> SW GSO:
> >> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
> >> ========================================================================
> >> 1472            1070565.90      1015    724112  724112  100     10.15
> >> 2944            1201579.19      1140    406342  406342  95.69   11.91
> >> 5888            1201217.55      1140    203185  203185  55.38   20.58
> >> 11776           1201613.49      1140    101588  101588  42.15   27.04
> >> 23552           1201631.32      1140    50795   50795   35.97   31.69
> >> 47104           1201626.38      1140    25397   25397   33.51   34.01
> >> 61824           1201625.52      1140    19350   19350   32.83   34.72
> >>
> >> HW GSO Offload:
> >> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
> >> ========================================================================
> >> 1472            1058681.25      1004    715954  715954  100     10.04
> >> 2944            1201730.86      1134    404254  404254  61.28   18.50
> >> 5888            1201776.61      1131    201608  201608  30.25   37.38
> >> 11776           1201795.90      1130    100676  100676  16.63   67.94
> >> 23552           1201807.90      1129    50304   50304   10.07   112.11
> >> 47104           1201748.35      1128    25143   25143   6.8     165.88
> >> 61824           1200770.45      1128    19140   19140   5.38    209.66
> >>
> >> i40e::
> >> SW GSO:
> >> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
> >> ========================================================================
> >> 1472            650122.83       616     439362  439362  100     6.16
> >> 2944            943993.53       895     319042  319042  100     8.95
> >> 5888            1199751.90      1138    202857  202857  82.51   13.79
> >> 11776           1200288.08      1139    101477  101477  64.34   17.70
> >> 23552           1201596.56      1140    50793   50793   59.74   19.08
> >> 47104           1201597.98      1140    25396   25396   56.31   20.24
> >> 61824           1201610.43      1140    19350   19350   55.48   20.54
> >>
> >> HW GSO offload:
> >> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
> >> ========================================================================
> >> 1472            657424.83       623     444653  444653  100     6.23
> >> 2944            1201242.87      1139    406226  406226  91.45   12.45
> >> 5888            1201739.95      1140    203199  203199  57.46   19.83
> >> 11776           1201557.36      1140    101584  101584  36.83   30.95
> >> 23552           1201525.17      1140    50790   50790   23.86   47.77
> >> 47104           1201514.54      1140    25394   25394   17.45   65.32
> >> 61824           1201478.91      1140    19348   19348   14.79   77.07
> >>
> >> I was not sure how to proper attribute Alexander on the ixgbe patch so
> >> please adjust this as necessary.
> >
> > For the ixgbe patch I would be good with:
> > Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > The big hurdle for this will be validation. I know that there are some
> > parts such as the 82598 in the case of the ixgbe driver or 82575 in
> > the case of igb that didn't support the feature, and I wasn't sure
> > about the parts supported by i40e either.  From what I can tell the
> > x710 datasheet seems to indicate that it is supported, and you were
> > able to get it working with your patch based on the numbers above. So
> > that just leaves validation of the x722 and making sure there isn't
> > anything firmware-wise on the i40e parts that may cause any issues.
>
> Thanks for feedback Alex.
>
> For validation, I will look around and see if we have any of the above
> chips in our testbeds. The above #s are from i210, 82599ES, and x710
> respectively. I'm happy to share my wrapper script for the gso selftest
> if others have the missing chipsets and can verify.
>
> Thanks!
> Josh

If you could share your test scripts that would be great. I believe
the networking division will have access to more hardware so if you
could include Aaron, who I added to the Cc, in your reply with the
script that would be great as I am sure he can forward it on to
whoever ends up having to ultimately test this patch set.

I'll keep an eye out for v2 of your patch set and review it when it is
available.

Thanks.

- Alex
