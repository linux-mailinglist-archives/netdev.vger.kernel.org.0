Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7F1281C6
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfLTSB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:01:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54530 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfLTSB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:01:26 -0500
Received: by mail-pj1-f68.google.com with SMTP id kx11so319123pjb.4;
        Fri, 20 Dec 2019 10:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QfkiIhsrv51gpnAU/wXArCyH7nSkKGuTujHi7jMqn60=;
        b=ky1TtQkiP1ey8yFLZ3pBK1jBDNUUmbFQR2bxVreYkzE+rZiwI0FUyBapYjWRXONV9w
         dkT5SkAMeZgHxEzHUmWyFNzaOagM4BzkYSx7Na4XB85mNFq8n3U7dR1PHITOdtEpq6PQ
         Vi+/wLz7ILNe7pcMihESquOKP9orJXJOeaex3LcdMesqkPuPCcVLDXb7taRXA+WU3+H8
         uB/deJKXYPPrVVyeaFAR8DQ+4T70Yo30jnZLlRWOlrnzHkMo+iINRLPnLf5PQx5MPCb3
         FRQvqzqSH9QgqJhcoz6Ap93iJWEhaNKuHxeD2YIL78CHxwzpbPfTPTlpFDlT9kKPWq71
         Oxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QfkiIhsrv51gpnAU/wXArCyH7nSkKGuTujHi7jMqn60=;
        b=pObLgu1N3SKWU2B1sq1J68ZbzoIMgYnqIJ71qi4VH7uEjgpNMRjJGdyesBgqO3PDG9
         BPvyVTM96OAkle70ea3ARC1Ae7DeBQUkKddVmbmyWKozvRWeR5oPuZN7ARL0AWYgZBoS
         8preXXysI450rE3+lYmAim4plkAJWe8CyKYFj/eDTWsnksaESa8apJgvMC9eTp6OZ9eS
         ILUww9+W/CAhzefrSKLleKB5FTM55dgxUL1sv/v3SHVn4GDzZGA+A94UVAFBFDMPsT3P
         EYAVM+9y13Z8Bjy2Q9Xf0o64jtjoYN5s5se7+saEklFvNVZ7esDhKvZtsE86IEvyCDk9
         bNFQ==
X-Gm-Message-State: APjAAAVaBqm+j65OUxRVaTUrHZ40cfasJxUS++ttVU+QbG/PLumH/gUe
        6VL7dz+729BGO5jBLmlOMyM=
X-Google-Smtp-Source: APXvYqxiY8v7P2ECjAmG0887Br7C9pWZhpZv3nUsRNTAWgxiBii0nx5tn+BpAqmoAc//Tnwzm0S9IQ==
X-Received: by 2002:a17:902:6bc3:: with SMTP id m3mr16045597plt.185.1576864886201;
        Fri, 20 Dec 2019 10:01:26 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u7sm13146794pfh.128.2019.12.20.10.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:01:25 -0800 (PST)
Date:   Fri, 20 Dec 2019 10:01:22 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 06/11] net: Introduce a new MII time stamping
 interface.
Message-ID: <20191220180122.GB3846@localhost>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <28939f11b984759257167e778d0c73c0dd206a35.1576511937.git.richardcochran@gmail.com>
 <20191217092155.GL6994@lunn.ch>
 <20191220145712.GA3846@localhost>
 <20191220153359.GA11117@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220153359.GA11117@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 04:33:59PM +0100, Andrew Lunn wrote:
> The Marvell PHY datasheets indicate they support PTP. I've not looked
> at how they implement it, and if the current model will work.

IIRC, those parts time stamp on the MII bus input, and not in the PHY
itself, and so they offer no advantage over MAC time stamping.  I
suspect that is why there has been so little interest.

Thanks,
Richard




