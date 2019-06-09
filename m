Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639343A36D
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 04:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfFICwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 22:52:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36832 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfFICwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 22:52:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so3178128pgb.3
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 19:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LNVIehnZzT2GPOtunR+Gp0cqiz2RUe53xfQ2OhnIAtk=;
        b=aUMbbisS0Vr9k9hg7bGLmiBVA7H0zY5AWfNH/DEiMIK6PKgw9lyg/HonlkGHQSnRZd
         0tfGNohnaMWc8Xjp1UHacaXfssVLcEVG0zVL2AJC/eZ/eD6O+QDR66qXfk0k3vZqsOLB
         63OmTwiVQ08lZm0IqetTVzZxYCRqq9Kg0qzDzw9NT/nSsYRFfyJvlC1EEjiW4trLDx1P
         sMJqF0J98h2P3xYTaBLlgKNVrTorm4CLTIByS2n9J/RM9iD0sZNZJ7QPWtIIUDV3AGeD
         aYYQJy0EEtQRYfn3omeus7S5x306S605lijRgPzYJYLndLZWjVbfXnPyG8iyibkpgGY4
         jYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LNVIehnZzT2GPOtunR+Gp0cqiz2RUe53xfQ2OhnIAtk=;
        b=Tzn1drFeORaR5PpUUnW0DtfthwP/xVqlXADKAaInggXNaHTQJNet5rREQasptElfz1
         lNN/hhTSJZXeymTzYQgXJqfe01OGezL/iVwYaW0igEzL30ur9x8UWJIRoQO7W3Jt2YWW
         P1DpII6kWaA37ecNTVM5L8VsD7QOZFU8MtWR9NOCYunNzHpTpVHkhMw14pHMTa95dcJ6
         75OaMeKKy/CdlJclVpR9pCC9/9HDKj2Thij04rhxg+Y8bFxGGnDpJtvypVqkGJiad8pG
         cVDpZjxrKoOZD9JpM9tye8uKeo/dSnNB2SIFERdtLhw+7TaxfN90ShbqRKNmzziNP+jC
         RoBw==
X-Gm-Message-State: APjAAAWd7KqcVzQOD8BFfFtRAQymiy4XTCLILe0Z+UYNWt7Vx6AoLXqY
        qZ48X21ufzNldyOiHEwS5rhafDDg
X-Google-Smtp-Source: APXvYqyQsnxFfz2G5/oVSs2OdKl28kEPh0SSy62oCYsLnQpB8GNCf+WmUdddW9Ch2mmCv3Jc7p2NYg==
X-Received: by 2002:a65:484d:: with SMTP id i13mr9603711pgs.27.1560048760265;
        Sat, 08 Jun 2019 19:52:40 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id c12sm6379094pfn.104.2019.06.08.19.52.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 19:52:39 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: dsa: sja1105: Use
 SPEED_{10,100,1000,UNKNOWN} macros
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <206b984d-eb04-da62-a730-3a854c2bb3e1@gmail.com>
Date:   Sat, 8 Jun 2019 19:52:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190608130344.661-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/2019 6:03 AM, Vladimir Oltean wrote:
> This is a cosmetic patch that replaces the link speed numbers used in
> the driver with the corresponding ethtool macros.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
