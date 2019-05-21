Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01B6259AC
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfEUVII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:08:08 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37521 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbfEUVIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 17:08:07 -0400
Received: by mail-pl1-f194.google.com with SMTP id p15so9015663pll.4
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 14:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HlvQTQMklmKckv+O3yWzE9c2yMblLgQuUNKX0KgOtjs=;
        b=QIHvzNhCbj+23QB9Bi9q6CK4dUYKQ6Tu6xJULd2tpo1CH4FQtWMcR/P2gM2gxNV/9D
         PITmQ1JTCOIJ5UcEKnDTuCV7hxyeIG5Yk77Cwomgh9KhqKGgGKMH7T4prTCEA8l1/Ihw
         imqO4qYFo6hofdKWWOlfCu62f9hGV/UNvowUC4jIH6yg81fjQmYjIjUzHWCJZFBKR88W
         Bewnb6tCLPVn8NGA5oLimVAHMYaGCYxqE2bByAQXi12hyAtd1k1h3Re1+TJTy1yZIeyV
         2tGZA6G57QSJBBYjp2fMoOB+nDrxrOzLdl76nTIZSflYMiXbB3HwVCPo5AWqaSclrp5N
         /Fog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HlvQTQMklmKckv+O3yWzE9c2yMblLgQuUNKX0KgOtjs=;
        b=R5nfdqJECErNTSnltnc/ABuZFp2IUJCfT6QY1ff0Gg3YsgevhO6wQEUwJlCzKjWmDl
         ENLRzSFvDoYpfKiXq7WQvSvmar5Cu5uWQeGtorfvCwvQPphTC9QcTI3rZzkkjyYa0vEz
         iOokqGgU5DOXJSdkmRjwPm3Jx1LofKY3+HOil0gJwf058binca0dd39IjM08LxOEWKxm
         83puivfvnE0L7UixRKXPt2CHccPwwt0qF8EoMM5xvzSjxkmVzdHf6gcqMv+0HEtCJZeg
         oGPEFm2F3auc5lJturIsLUPw15yxlg3JpHzd4cZ9Ia2J/gBTuVhhA1qJMKJphL6m6XNI
         hlxw==
X-Gm-Message-State: APjAAAXTcfO6T/bmltBUkxBhbdgfo8Yf/VWfWGpzji2yv6o+K0JT3C1D
        2yOiOvCLlfMDI6fBkauGqn3DtQ==
X-Google-Smtp-Source: APXvYqxy/rrci31P1jKsWK9dV+iuPHdPoV0C73+MG7ojS8DF/oVUA8wmHC34jvC9g26bI6aN6dUZtA==
X-Received: by 2002:a17:902:a415:: with SMTP id p21mr72030352plq.286.1558472886424;
        Tue, 21 May 2019 14:08:06 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id u1sm33700298pfh.85.2019.05.21.14.08.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 14:08:05 -0700 (PDT)
Date:   Tue, 21 May 2019 14:08:04 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Alex Elder <elder@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] net: qualcomm: rmnet: Move common struct definitions
 to include
Message-ID: <20190521210804.GR31438@minitux>
References: <1558467302-17072-1-git-send-email-subashab@codeaurora.org>
 <CAK8P3a0JpCnV59uWmrot7KeLPCOq_FqPb--xD_fMpaPd7x0zRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0JpCnV59uWmrot7KeLPCOq_FqPb--xD_fMpaPd7x0zRg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 21 May 13:45 PDT 2019, Arnd Bergmann wrote:

> On Tue, May 21, 2019 at 9:35 PM Subash Abhinov Kasiviswanathan
> <subashab@codeaurora.org> wrote:
> >
> > Create if_rmnet.h and move the rmnet MAP packet structs to this
> > common include file. To account for portability, add little and
> > big endian bitfield definitions similar to the ip & tcp headers.
> >
> > The definitions in the headers can now be re-used by the
> > upcoming ipa driver series as well as qmi_wwan.
> >
> > Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> > ---
> > This patch is an alternate implementation of the series posted by Elder.
> > This eliminates the changes needed in the rmnet packet parsing
> > while maintaining portability.
> > ---
> 
> I think I'd just duplicate the structure definitions then, to avoid having
> the bitfield definitions in a common header and using them in the new
> driver.
> 

Doing would allow each driver to represent the bits as suitable, at the
cost of some duplication and confusion. Confusion, because it doesn't
resolve the question of what the right bit order actually is.

Subash stated yesterday that bit 0 is "CD", which in the current struct
is represented as the 8th bit, while Alex's patch changes the definition
so that this bit is the lsb. I.e. I read Subash answer as confirming
that patch 1/8 from Alex is correct.


Subash, as we're not addressing individual bits in this machine, so
given a pointer map_hdr to a struct rmnet_map_header, which of the
following ways would give you the correct value of pad_len:

u8 p = *(char*)map_hdr;
pad_len = p & 0x3f;

or:

u8 p = *(char*)map_hdr;
pad_len = p >> 2;


PS. I do prefer the two drivers share the definition of these
structures...

Regards,
Bjorn
