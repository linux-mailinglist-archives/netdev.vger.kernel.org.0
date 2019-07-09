Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE00A63863
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfGIPKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:10:44 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43571 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGIPKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:10:44 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so43843395ios.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 08:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9QxAes6NpAQQFVrPl0OtPYg42YgkXbZao/s916d4Emc=;
        b=1F6cgkUO70L7LaCwq766Y7xSs+APYD+tLWX8JhALsPCHTT4tCz2V9S2JBvkBIDbYVh
         bZowJX+I7VdgAnVSVWUF/l3OnR4FNrxO4AWTY/f2CCyOdsSmWerfPL97YoHFn0QhYFKu
         edD3WiVnSSAnoN8Pp7XYBMLXvQFTdYjQyTLt6TSWbzHlvCOOB8XifkJNiVZ6Fm+swA5N
         yCaY2uDX6Cq7NRxQXxJahSMUee3gIAOy7b8wb/0w0kbD2Y81dm92ub4x+y4UPm41qD6W
         jVsqgGFx41H1/gkv7DBw9PrYjyky6opUOqWMS819BlTYvyKmPde4DVVGmnFXCEUv0lwi
         SiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9QxAes6NpAQQFVrPl0OtPYg42YgkXbZao/s916d4Emc=;
        b=DImTT7yNt7unp/p6z2UxcdoRk4khlh55g3MvQhmFBq58xbjx7L/2d8YYpTaRrjZegg
         AaetgK53puLpEyja/UjqiEiWrsWT8yG8FD77qY6ew0MUi9kOFRAjjycZqV0agez1Nr8c
         tyKZzONe0j+dn8afClnL3QeJiwM+JWb57wJpW3bg4PAegi7zqkMCISAS80ZrvjYND01/
         PgJ3DOWv1OlkjROoGC3U8dluhvWVEZZ7eepMQrniwfn5p/ybnIDunKDA6KmTwO6a28/u
         hRxTevAwxgamu075imf1EF+Kcm4ufKr+foBxp9XfpwhfrQUJJyfg3j/EPUf0zKSzQhhl
         qEpQ==
X-Gm-Message-State: APjAAAVIhfVqv3jrzvuHCXeMREx2Ie9nvA5DtkPO+/xS3YTKWuf2NSvb
        cy7O/Mxn108QCdsEpRrNUmw/bg==
X-Google-Smtp-Source: APXvYqyAaDGdykzeJn6um9pcdpnQuGteTV6ON754WKwUCZKU/C8/KSXHXt7Q2XJrQKeikyfC12H58g==
X-Received: by 2002:a6b:f203:: with SMTP id q3mr24425999ioh.208.1562685043251;
        Tue, 09 Jul 2019 08:10:43 -0700 (PDT)
Received: from x220t ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id a7sm17985158iok.19.2019.07.09.08.10.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Jul 2019 08:10:42 -0700 (PDT)
Date:   Tue, 9 Jul 2019 11:10:40 -0400
From:   Alexander Aring <aring@mojatatu.com>
To:     Lucas Bates <lucasb@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>, kernel@mojatatu.com
Subject: Re: [PATCH v2 net-next 3/3] tc-testing: introduce scapyPlugin for
 basic traffic
Message-ID: <20190709151040.unyrfau2ajypqcl4@x220t>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
 <1562201102-4332-4-git-send-email-lucasb@mojatatu.com>
 <20190704202909.gmggf3agxjgvyjsj@x220t>
 <CAMDBHYKwxnJYMp97vMmhZR5unqT7LyXivhqFm+-Vc59LMqmO4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMDBHYKwxnJYMp97vMmhZR5unqT7LyXivhqFm+-Vc59LMqmO4A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 09:28:09PM -0400, Lucas Bates wrote:
> Sorry Alex, I completely forgot about this email.
> On Thu, Jul 4, 2019 at 4:29 PM Alexander Aring <aring@mojatatu.com> wrote:
> >
> > Hi,
> >
> > On Wed, Jul 03, 2019 at 08:45:02PM -0400, Lucas Bates wrote:
> > > The scapyPlugin allows for simple traffic generation in tdc to
> > > test various tc features. It was tested with scapy v2.4.2, but
> > > should work with any successive version.
> > Is there a way to introduce thrid party scapy level descriptions which
> > are not upstream yet?
> 
> Upstream to scapy? Not yet.  This version of the plugin is extremely
> simple, and good for basic traffic.  I'll add features to it so we can
> get more creative with the packets that can be sent, though.
> 

Can you add this now? I have some tests here for ife and I am on the way
to send it upstream to scapy.

So far this isn't done yet, I like to provide them via a external
directory in the tctesting directory.

Thanks.

- Alex
