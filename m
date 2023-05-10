Return-Path: <netdev+bounces-1496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CEA6FE03E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96F6F280FCB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D20A14AB2;
	Wed, 10 May 2023 14:29:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF7912B74
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:29:57 +0000 (UTC)
X-Greylist: delayed 1862 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 May 2023 07:29:55 PDT
Received: from bosmailout06.eigbox.net (bosmailout06.eigbox.net [66.96.188.6])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87461A7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:29:55 -0700 (PDT)
Received: from bosmailscan05.eigbox.net ([10.20.15.5])
	by bosmailout06.eigbox.net with esmtp (Exim)
	id 1pwkLD-0005gp-9b
	for netdev@vger.kernel.org; Wed, 10 May 2023 09:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=boscustweb2406.eigbox.net; s=dkim; h=Sender:Date:Content-type:MIME-Version:
	From:Subject:To:Message-Id:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cQWOKmoZIdiShhyWYmoys77xDaX7An/CU+vXO8mJaW0=; b=R6ZqSSDQY+sdMcOOgqmoQJMDNa
	7Dso4ziAMQfiwnpUKfS5dUtfPdJEGTRqA9opUJZZN3KsGDKYp4MnyK5s2CWhFbuyOhjzzaNIpJPJG
	nyzHoRMvRJVAu9TpU4pnloIdot+URhs8dtfF/Sjwo9TBhoCpjuk3v0C4piJNT8SU9BPU74Xmh/Spw
	S2hKTpmpPMAQA8UimgTggS5gCpZd5wc5TW2M9c6viM/kg4SQ2GToMEwdUDUJeFIzRSkkWBF+IAVIm
	Uu9r6LKnUDauhTsthEHsSlkXbUmnM/42QXNprLri3CQsdLQ/9UlLP5RPL9tcIJqIi+c2zaRS7oPgI
	fyPPB4bA==;
Received: from [10.115.3.32] (helo=bosimpout12)
	by bosmailscan05.eigbox.net with esmtp (Exim)
	id 1pwkLC-0001K6-LP
	for netdev@vger.kernel.org; Wed, 10 May 2023 09:58:50 -0400
Received: from boscustweb2405.eigbox.net ([10.20.112.174])
	by bosimpout12 with 
	id v1yn290173loz5m011yqpp; Wed, 10 May 2023 09:58:50 -0400
X-EN-SP-DIR: OUT
X-EN-SP-SQ: 1
Received: from dom.dowanilamalicom by boscustweb2405.eigbox.net with local (Exim)
	id 1pwkBI-0000ZJ-Ol
	for netdev@vger.kernel.org; Wed, 10 May 2023 09:48:36 -0400
X-EN-Info: U=dom.dowanilamalicom P=/ap.php
X-EN-CGIUser: dom.dowanilamalicom
X-EN-CGIPath: /ap.php
X-EN-OrigIP: 105.154.227.95
Message-Id: <1683726516-182-dom.dowanilamalicom@boscustweb2405.eigbox.net>
To: netdev@vger.kernel.org
Subject: =?UTF-8?B?2KfZhNit2LLZhdipINin2YTYrtin2LXYqSDYqNmDINiq2YbYqti42LEg2KfZhNiq2LPZhNmK2YUu?=
X-PHP-Originating-Script: 10812606:ap.php
From: =?UTF-8?B?QXJhbWV4IFN1cHBvcnQ=?= <no-reply@boscustweb2406.eigbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0;
Content-type: multipart/mixed; boundary="--CHKzulsY9F"
X-EN-Timestamp: Wed, 10 May 2023 09:48:36 -0400
Date: Wed, 10 May 2023 09:48:36 -0400
Sender:  Aramex Support <no-reply@boscustweb2406.eigbox.net>
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_50,BOGUS_MIME_VERSION,
	DKIM_INVALID,DKIM_SIGNED,FROM_EXCESS_BASE64,HTML_FONT_LOW_CONTRAST,
	HTML_MESSAGE,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

----CHKzulsY9F
Content-type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit


<table valign="top" width="600" cellspacing="0" cellpadding="0" border="0" align="center">
    <tbody><tr>
        <td width="600">
            <div><div><div></div>
</div><div><div><div>


<table style="background-color:#f1f1f1" width="100%" cellspacing="0" cellpadding="0" border="0">
    <tbody><tr>
        <td style="text-align:center;font-size:11px;color:#189aca;font-family:sans-serif;padding:10px 0">
              </td>
    </tr>
</tbody></table>

<table style="background-color:#dc291e" width="100%" cellspacing="0" cellpadding="0" border="0">
    <tbody><tr>
        <td style="padding:30px 15px">
            <table style="background-color:#dc291e" width="100%" cellspacing="0" cellpadding="0" border="0">
                <tbody><tr>
                  <td width="180">

                    <a href="#m_5271972809205713416_">
                        <img style="display:block;border:0;width: 180px;" src="https://i.ibb.co/qgnw3SP/aram.png" alt="Logo Alt text">
                    </a>
                  </td>
                    <td style="text-align: left;" width="200">
                      <a href="" style="text-align:left;color:#333333;font-size:14px;font-family:sans-serif;text-decoration:none">
                        
                      </a>

                    </td>

                </tr>
            </tbody></table>
        </td>
    </tr>
</tbody></table>
</div>
</div>
</div>
</div>

        </td>
    </tr>
    <tr>
        <td width="600">
            <div>





    <div>




    <p style="font: small/1.5 Arial,Helvetica,sans-serif;font-family: Arial,Helvetica,sans-serif;">عزيزي العميل,</p>



</div>




    <div>



    <p style="font: small/1.5 Arial,Helvetica,sans-serif;font-family: Arial,Helvetica,sans-serif;">لديك طرد في مكتب البريد و هو بانتظار تأكيد دفع تكاليف التوصيل، يمكنك دفع هذه الرسوم عن طريق النقر على الرابط أدناه. يرجى تأكيد شحن الطرد إلى منزلك في غضون ٤٨ساعة وإلا سيتم إعادته إلى المرسل.
</p>



</div>




    <div>








<div style="text-align:center">
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
        <tbody><tr>
            <td align="center">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tbody><tr>
                        <td style="padding:10px 15px;background:#dc291e;border-radius:2px">
                            <a style="font-family: Arial,Helvetica,sans-serif;font-size:18px;font-weight:bold;color:#ffffff;text-decoration:none;display:inline-block" href="https://t.co/7lxmA8iU2A">ادفع الآن</a>
                        </td>
                    </tr>
                </tbody></table>
            </td>
        </tr>
    </tbody></table>
</div></div>




    <div>



    <p style="font: small/1.5 Arial,Helvetica,sans-serif;font-family: Arial,Helvetica,sans-serif;">قد نطلب أيضا توقيع.
</p>
<p style="text-align: center;"><a style="font-family: Arial,Helvetica,sans-serif;padding:10px 15px;background:#dc291e;border-radius:2px;font-size:18px;font-weight:bold;color:#ffffff;text-decoration:none;display:inline-block" href="https://t.co/7lxmA8iU2A">عرض خيارات التسليم </a></p>

<p style="font: small/1.5 Arial,Helvetica,sans-serif;font-family: Arial,Helvetica,sans-serif;font-weight:bold;">مدة التسليم قد تتأخر بمدة لا تفوق ٢٤ ساعة.</p>



</div>




    <div>



    <p></p><p style="font: small/1.5 Arial,Helvetica,sans-serif;font-family: Arial,Helvetica,sans-serif;">مع أطيب التحيات,</p>
<p style="font: small/1.5 Arial,Helvetica,sans-serif;font-family: Arial,Helvetica,sans-serif;">أرامكس </p>
<p></p>



</div>




    <div>



    <p style="text-align:center"><span style="font-size:10.0px;font-family: Arial,Helvetica,sans-serif;">هذا هو البريد الإلكتروني الذي تم إنشاؤه تلقائيا ، لا يمكننا الإجابة على الرد على هذا البريد </span></p>



</div>


</div>
        </td>
    </tr>
    <tr>
        <td width="600">
            <div><div><div></div>
</div><div><div><div>


<table style="background-color:#f1f1f1" width="100%" cellspacing="0" cellpadding="0" border="0" align="center">
    <tbody><tr>
        <td style="font-size:0;line-height:0">
            <img style="display:block;border:0" src="https://i.ibb.co/1QLxxtL/arrr.png" alt="Footer Alt Text" width="100%">
        </td>
    </tr>
    <tr>
        <td style="padding:5px 15px">
            <table style="background-color:#f1f1f1" width="100%" cellspacing="0" cellpadding="0" border="0">
                <tbody><tr>
                    <td style="color:#7a7a7a;font-size:10px;font-family:sans-serif">

                        <a style="color:#15c;" href="">الشروط والأحكام</a>


                            |

                        <a style="color:#15c;">الخصوصية</a>


                            |

                        <a style="color:#15c;" href="">الشروط العامة للنقل</a>
                    </td>
                    <td style="border-left:1px solid #f1f1f1" width="200" align="right">
                        <span style="color:#7a7a7a;font-size:10px;font-family:sans-serif"> © أرامكس 2023. جميع الحقوق محفوظة.
</span>
                    </td>
                </tr>
            </tbody></table>
        </td>
    </tr>
</tbody></table>
</div>
</div>
</div>
</div>

        </td>
    </tr>
</tbody></table>

----CHKzulsY9F


