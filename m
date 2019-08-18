Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60F391974
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 22:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfHRULy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 16:11:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44800 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfHRULx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 16:11:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so4734787plr.11;
        Sun, 18 Aug 2019 13:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jK4nxwdgBuyoD1ZnaAuxfcxRj0U0B/VNxYmenqTfaAY=;
        b=by89bBijWdxceRG2lqxJcbcn6ff10EqqqqKKnaLaq9SL4A3+Z6q5D25qGSzHKdyN3A
         ExzMi0SMG9ZkFfD+Th9MP3Fs5dEGGJ9lNU86bs9fawK9H09tLiFSP0PSRUTJX4o9G8D1
         oj023eB+rj9UCrtSdzBCKsHaVTwo4W3+pPQtHQ5ckxjMPZEqJXm98Mr4cd/G0JgZbeGM
         53Xr5UYKlvzUVwG1aVja759KAKEQQPcfi287UfU4rRyVWzieTo6jC/LOP2LOXw2Acuma
         0WyReRc8exu3Ko7qdlTrNYqdM3CR04YX3OF4q/WT6uGguFmKT+sCUaLhMzkUHX+NsEMW
         QWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jK4nxwdgBuyoD1ZnaAuxfcxRj0U0B/VNxYmenqTfaAY=;
        b=AuSmthIKmWcNpk4TjRfSKA19NHOm1lEC2fjIr+LNqY12BKn9OwnK8qzcc5IgrwZZsk
         UrtAROgtNQu7yq2Mycp2REwF4KwzAerhsgue1aijB6KMRbiAix15sYdmfSovV91d5//O
         e5jbvufN3lLflP1JxEM8RdZh1eRYdnGopqWs/n1iNBt+QtW7eZayc9lYlXqrIfYIJT/T
         QlRC6M1G2JhkHBRynVCOOnAFoNCn8w54SlipNn0kLZWSKAsM7yxJ7uSY8BLPaDYWSjXM
         vJBWA+V1+JpGGP4g/kLvlJqPcxaIqU7h7PnZtjzJ+z7fu9SXSlMIY2/chfQL+oKwlpYV
         rRSQ==
X-Gm-Message-State: APjAAAV8bVj2GMYGnhoLtvzjcidfS4PLwqKHNW2maJpKrx+yQ/3ETdDv
        weW2zWNYfDbInrNdQCmzVPo+ciP3
X-Google-Smtp-Source: APXvYqzdsGCudhJ6cr8UVvcFNPZGEVQ3JalHpugLehZgImc71Bw7PqTyNi8RW0BkMSP3OesKwf7B7w==
X-Received: by 2002:a17:902:20e5:: with SMTP id v34mr19293586plg.136.1566159113082;
        Sun, 18 Aug 2019 13:11:53 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id c35sm12073966pgl.72.2019.08.18.13.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 13:11:52 -0700 (PDT)
Date:   Sun, 18 Aug 2019 13:11:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PTP: introduce new versions of IOCTLs
Message-ID: <20190818201150.GA1316@localhost>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
 <20190817155927.GA1540@localhost>
 <a146c1356b4272c481e5cc63666c6e58b8442407.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a146c1356b4272c481e5cc63666c6e58b8442407.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 17, 2019 at 09:17:20AM -0700, Joe Perches wrote:
> Is there a case where this initialization is
> unnecessary such that it impacts performance
> given the use in ptp_ioctl?

None of these ioctls are sensitive WRT performance.  They are all
setup or configuration, or in the case of the OFFSET ioctls, the tiny
extra delay before the actual measurement will not affect the result.

Thanks,
Richard
