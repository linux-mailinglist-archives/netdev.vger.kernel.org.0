Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52747222E9B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGPXJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgGPXI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:08:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678DBC08C5FC
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 16:02:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mn17so5569023pjb.4
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 16:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o34IXxwMd0vyXPXKCO7aCODA+f7Id4gHfhq7U+7jaNk=;
        b=WjdQTm8aSPxAFIR1XHrtKEUFFYCsb8iNysoyMIb2C3cyrJ2fqOEBDlvq7qfcClRVBm
         TKexTWb8BM589sBcA1WM7s42f8yW/+LGJQ2wH1ggnP1RVW6z8A/v2Kxg3SSqH7pa0eAc
         TedlideckLVfO4AhX/ICm7Tb70/aQsOlapT6XDamb+4uvMLE3ZAkfsKchXx6aaDtwiME
         QPnfuwA2JbU5uTv8WYbrAPxIMed6rg3ILUw3IqUI34V2pCyex9Vm7Nl7ceisF20a40wr
         dyJZqKbujVMxlAD8u/YsZodFc67acY0eLIOOPYi2a3quD+PJuVk5aysfayT0MuKJnOLa
         pF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o34IXxwMd0vyXPXKCO7aCODA+f7Id4gHfhq7U+7jaNk=;
        b=FL959isPbElT03NMzLCU3gD3d9VcEgDZMyFQWoabsxPVhSda765MlXEh1ctKNMINt9
         uiAdwXF+pb28TaIFvA6614vp7yB30P81D7xADodqX/AVkt0UFpX7xg9aSSN1ldn0clcg
         6RiwojuaCtkz0sTZJo8NOrdU7HDHPQecFmrbWQaMYaqTXYSd4vFJp+4+rdiaJYgP4snd
         CqxXQPo57YACenXBVT7NXqmd9AiZgT0DOn2r5jBVB/ketqYzhMO7EWRmKvQC2KSNBy1v
         DM8ozGDqVMzVXyLPpOM1nNvgKjgHMrsWgQWE/vX/pWO6+DghwMGuhGGpUVWq9NQl1RRY
         kwgQ==
X-Gm-Message-State: AOAM531pP7WB2tw43PKut3LT6zTi3HLsA2J6q3MBsAE8fzWDmCntOIlk
        /C4yKuGF8RqFa40Bvv6ZS1tTiA==
X-Google-Smtp-Source: ABdhPJzmGDjORCq/34Hb1CaobVrLOJSw2mr3H9dugsf1kG/3uduTIiE1l8i9bOvSVafhFohCwcc8MA==
X-Received: by 2002:a17:902:7005:: with SMTP id y5mr4906865plk.342.1594940521833;
        Thu, 16 Jul 2020 16:02:01 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y9sm885015pju.37.2020.07.16.16.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 16:02:01 -0700 (PDT)
Date:   Thu, 16 Jul 2020 16:01:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     jarod@redhat.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [RFC] bonding driver terminology change proposal
Message-ID: <20200716160152.026ace81@hermes.lan>
In-Reply-To: <20200716.115947.741360685940124518.davem@davemloft.net>
References: <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
        <20200713.180030.118342049848300015.davem@davemloft.net>
        <CAKfmpSeqqD_RQwdFwsZG212tbNF0E__83xKWT44nGYs4AOjDJw@mail.gmail.com>
        <20200716.115947.741360685940124518.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 11:59:47 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Jarod Wilson <jarod@redhat.com>
> Date: Wed, 15 Jul 2020 23:06:55 -0400
> 
> > On Mon, Jul 13, 2020 at 9:00 PM David Miller <davem@davemloft.net> wrote:  
> >>
> >> From: Michal Kubecek <mkubecek@suse.cz>
> >> Date: Tue, 14 Jul 2020 00:00:16 +0200
> >>  
> >> > Could we, please, avoid breaking existing userspace tools and scripts?  
> >>
> >> I will not let UAPI breakage, don't worry.  
> > 
> > Seeking some clarification here. Does the output of
> > /proc/net/bonding/<bond> fall under that umbrella as well?  
> 
> Yes, anything user facing must not break.
> 

For iproute2, would like better wording on the command
parameters (but accept the old names so as not to break scripts).
The old names can be highlighted as for compatibility only
or removed from the usage manual and usage.

Internally, variable names and function names can change iproute2
since the internal API's are not considered part of user API.
