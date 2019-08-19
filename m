Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD778948B5
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfHSPnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:43:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40996 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbfHSPnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 11:43:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id 196so1380150pfz.8;
        Mon, 19 Aug 2019 08:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eV94SApWZTFweA/qwK/ErWJOHYhfzE92sQRqbCwLV9E=;
        b=E1hwBmAG+r761tHLSNhL8Yf8dofQ0qJwDAvMSAT3O4bJhJgUS+9Dqn1VsF4fUqPzu7
         vLqskfrtlEs7mNSflqoWWDDDTiamf3Z2Cp7Z9GYAEDIrvKz4s+x1SP1savoDBQ54uKKw
         H+qXTN28duDQPFXM9kG/HAS/rC9yR5yaN/9pYCkF2RZ4gabyXtS9zuiiO0RP/rxfmznu
         OPU/fuk6hK9yIppCZJ2TafIgCxWLPH5kbv438t8sS8SP3sTmYYZLaEaENKcg7GtSphF3
         LxFOiFcdjZsbCF2rpV//VdsKM9+b0QjCvjnK0MiOBkFTkEeeSdNZoeEN/xWJdiDdAQCZ
         XKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eV94SApWZTFweA/qwK/ErWJOHYhfzE92sQRqbCwLV9E=;
        b=aYObmW3O5LAEOm4iT22PGPWOQ3B8FJh1MY6II7fYFqogaRj+Zl01GHqt7JiBBaSzIw
         9wBBEKn+RlwV87cBEqEhBi7n7Eu5xxsRdCr7OxSFdrTMW/sKP6nlbW8CGj/YIryqDquV
         41w0lSs+PoC3jd42PH0Q7lo16htXaiUgskLl9dbDyYIM2tt6x+UCJdLlbQuwyLu8gQOx
         SwipLW94kCAxljd8LiMMN3WrGDhg4h/gJOAqPkjfH3ahhTo7gCVyM2Qc/D0M3Panh17U
         O1I5UXmQzjZ/LvKogXgKZQ0edOfyl5m+tNh29XMIcJo6ZQ6YcZk+REOL0EVy+p6km7dt
         gJ7A==
X-Gm-Message-State: APjAAAW7fFNLsbErEpd4vGx71zI3C0ct74xmvn0oF8dIze75zTI7ku4E
        CNiz02lL6xws3xNwE91VQEk=
X-Google-Smtp-Source: APXvYqyOdxQtsD5gKEcfQEmF7fnJv4q1CsPL02eETqip58Blor0faUe4mOdd7WihjMh6h6S495xcvA==
X-Received: by 2002:a63:5811:: with SMTP id m17mr20522184pgb.237.1566229403179;
        Mon, 19 Aug 2019 08:43:23 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id s14sm15785318pfe.16.2019.08.19.08.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 08:43:22 -0700 (PDT)
Date:   Mon, 19 Aug 2019 08:43:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PTP: introduce new versions of IOCTLs
Message-ID: <20190819154320.GB2883@localhost>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
 <20190817155927.GA1540@localhost>
 <a146c1356b4272c481e5cc63666c6e58b8442407.camel@perches.com>
 <20190818201150.GA1316@localhost>
 <83075553a61ede1de9cbf77b90a5acdeab5aacbf.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83075553a61ede1de9cbf77b90a5acdeab5aacbf.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 18, 2019 at 03:07:18PM -0700, Joe Perches wrote:
> Also the original patch deletes 2 case entries for
> PTP_PIN_GETFUNC and PTP_PIN_SETFUNC and converts them to
> PTP_PIN_GETFUNC2 and PTP_PIN_SETFUNC2 but still uses tests
> for the deleted case label entries making part of the case
> code block unreachable.
> 
> That's at least a defect:
> 
> -	case PTP_PIN_GETFUNC:
> +	case PTP_PIN_GETFUNC2:
> 
> and
>  
> -	case PTP_PIN_SETFUNC:
> +	case PTP_PIN_SETFUNC2:

Good catch.  Felipe, please fix that!

(Regarding Joe's memset suggestion, I'll leave that to your discretion.)

Thanks,
Richard
